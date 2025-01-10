# Making a systemd service that is resilent to crashes

In risk management, we consider trade-offs between reliability (frequency of failures),
resilience (ability to recover from a failure) and vulnerability (impact of a failure).
These trade-offs can be considered in the context of different types of software
applications. For example, an interactive CLI tool does not need to be very
resilent because a failure is immediately observed by the user. Alternatively,
a long running process like a server or background service might be expected to recover
from a crash by restarting. This demo is an example of that concept. A simple service
service is installed and run using systemd. The service expects a config file as input,
and crashes if the config file is unavailable. By adjusting the systemd unit file, we
can manipulate the resilience of this service.

### Example 1: Naive case

In this example, we have configured the app to "always" restart with a 100ms delay
between attempts. However, this configuration is misleading and does not accomplish
the "always" part. It tries 5 times and then gives up. This is because of the
`StartLimitIntervalSec` and `StartLimitBurst` behavior of giving up if it fails too
many times in a specific interval. The default values can be researched, but they
are certainly quite sensitive. 

```
[Unit]
Description=resilient-app
After=network.target

[Service]
Type=simple
SyslogIdentifier=resilient-app
User=resilient
Group=resilient
ExecStart=/opt/resilient-app/resilient-app -c /tmp/resilient.json
StandardOutput=journal+console
Restart=always
RestartSec=100ms

[Install]
WantedBy=multi-user.target
```

### Example 1: Naive case recovery

One would think that you can edit the config, issue a `systemctl restart resilient-app.service`
and it would be fine, but the restart counter isn't actually reset until the interval
has elapsed. So `systemctl restart APP` will actually fail with no action. If this
happens, you can recover by running `systemctl reset-failed`, followed by the
`systemctl restart APP`.

### Example 2: Perpetual linear restart

In this example, we added the `StartLimitIntervalSec=0` line to the unit section. This
tells systemd to ignore the interval and burst settings entirely and literally try
to restart every 100ms forever.

```
[Unit]
Description=resilient-app
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
SyslogIdentifier=resilient-app
User=resilient
Group=resilient
ExecStart=/opt/resilient-app/resilient-app -c /tmp/resilient.json
StandardOutput=journal+console
Restart=always
RestartSec=100ms

[Install]
WantedBy=multi-user.target
```

### Example 3: Perpetual restart with progressive backoff

Building on the previous example, we now added the `RestartMaxDelaySec=60s` and
`RestartSteps=10` settings to service section. These options are available in
Ubuntu 24+. In the event of a failure, restarts will begin retrying quickly, but
as more failures occur, the retries will be attempted farther apart, up until the
max of 60s is reached between attemts. At this point, any subsequent failures will
cause retries at the 60s interval and a `systemctl reset-failed` is required to
reset the backoff process.

```
[Unit]
Description=resilient-app
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
SyslogIdentifier=resilient-app
User=resilient
Group=resilient
ExecStart=/opt/resilient-app/resilient-app -c /tmp/resilient.json
StandardOutput=journal+console
Restart=always
RestartSec=100ms
RestartMaxDelaySec=60s
RestartSteps=10

[Install]
WantedBy=multi-user.target
```

### Example 3: Perpetual restart with progressive backoff - recovery

Since the counter won't be reset automatically, you can use a cron

```
# reset-failed at 4 am and 5 pm
# m h  dom mon dow   command
  0  4   *   *   *   systemctl reset-failed
  0 17   *   *   *   systemctl reset-failed
```
