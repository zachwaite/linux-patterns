# Migrating a lxc container

The recommended way was:

[https://discuss.linuxcontainers.org/t/backup-the-container-and-install-it-on-another-server/463](https://discuss.linuxcontainers.org/t/backup-the-container-and-install-it-on-another-server/463)

Direct quote:

> stgraber Stéphane Graber Maintainer Aug '17
>
> The cleanest and possibly easiest way to do so would be to add your second
> server as a remote with `lxc remote add`. You’ll then be able to just do
>
> `lxc copy CONTAINER_NAME/SNAPSHOT_NAME target:CONTAINER_NAME` And the target
> LXD will download the snapshot from the source LXD and then re-created the
> container with the exact same settings it had on the source.
>
> If you are tied to using tarballs, then the easiest is probably:
>
> lxc publish CONTAINER_NAME/SNAPSHOT_NAME --alias my-export lxc image export
> my-export . This will create a new LXD image from your container and export it
> as a tarball in your current directory. You can then ship that tarball to your
> target host and do:
>
> lxc image import TARBALL --alias my-export lxc init my-export NEW-CONTAINER
> But that’s quite a bit of indirection and you’ll then have to cleanup those
> temporary images and tarballs, … I’d strongly recommend just having the second
> LXD download the container from the first one.
