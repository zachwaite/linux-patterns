ssh -L 9000:localhost:9000 -o ExitOnForwardFailure=yes -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o "IdentitiesOnly yes" administrator@192.168.0.123 -p 22
