SHELL := /bin/bash
.ONESHELL:

.PHONY: watch serve

serve:
	uvicorn server:app --reload

reload:
	curl "http://localhost:8000/reload"

watch:
	while true; do\
		inotifywait -qr -e modify -e create -e delete -e move "$(shell pwd | xargs dirname)";\
		make reload;\
	done
