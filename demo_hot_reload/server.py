# inspired by https://gist.githubusercontent.com/francbartoli/2532f8bd8249a4cefa32f9c17c886a4b/raw/97a6e2d3982e51ba2728c52ed30cd6c3ec624a42/demo.py

from typing import List

from bs4 import BeautifulSoup
from fastapi import FastAPI
from starlette.responses import HTMLResponse
from starlette.websockets import WebSocket, WebSocketDisconnect


def socket_injector(html):
    soup = BeautifulSoup(html, "html.parser")
    head = soup.find("head")
    if head:
        script = soup.new_tag("script")
        script.string="""
                var ws = new WebSocket("ws://localhost:8000/ws");
                ws.onmessage = function(event) {
                    window.location.reload();
                };
        """
        head.append(script)
    return soup

app = FastAPI()

@app.get("/")
async def get():
    with open("./index.html", "r") as f:
        html_with_socket = socket_injector(f.read())
        return HTMLResponse(html_with_socket)


class Notifier:
    def __init__(self):
        self.connections: List[WebSocket] = []
        self.generator = self.get_notification_generator()

    async def get_notification_generator(self):
        while True:
            message = yield
            await self._notify(message)

    async def push(self, msg: str):
        await self.generator.asend(msg)

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.connections.append(websocket)

    def remove(self, websocket: WebSocket):
        self.connections.remove(websocket)

    async def _notify(self, message: str):
        living_connections = []
        while len(self.connections) > 0:
            # Looping like this is necessary in case a disconnection is handled
            # during await websocket.send_text(message)
            websocket = self.connections.pop()
            await websocket.send_text(message)
            living_connections.append(websocket)
        self.connections = living_connections


notifier = Notifier()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await notifier.connect(websocket)
    try:
        while True:
            _ = await websocket.receive_text()
    except WebSocketDisconnect:
        notifier.remove(websocket)


@app.get("/reload")
async def reload():
    await notifier.push("reload")


@app.on_event("startup")
async def startup():
    # Prime the push notification generator
    await notifier.generator.asend(None)
