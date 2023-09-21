# Run GUI app with systemd

Key Points:

- need to run as a user
- need to wait for a graphical session

Otherwise it's pretty much like a normal service

The `calc-forever` project can be used as a demo (tested on raspberry pi 4b).

Instructions:

1. Copy the project to the remote machine e.g
   `scp -r ./calc-forever pi@IP:/home/pi/`
2. Run the deploy script `cd ./calc-forever && bash ./deploy.sh`
