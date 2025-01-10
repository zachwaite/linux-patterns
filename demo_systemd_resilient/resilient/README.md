# resilient

Despite the name, this app is not resilient at all. It tries to read a config file
and print it, but exits if the config file is not found. The purpose is to allow shifting
some of the resilience responsibility from the app to systemd. The specific use case for
this would be if a database is unexpectedly down.
