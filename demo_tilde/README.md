# How Does `~` Work?

By example:

`cd ~` navigates to the current user's home directory `cd ~zach` navigates to
zach's home directory

So... we can use this knowledge to make special shortcuts, like

```bash
< ~~/get_data.sql zsql # run sql script that is in some directory
make -f ~%/build.mk    # run a makefile somewhere
```

To accomplish this, we need to add a nologin user named as the character you
want to use in your prefix, then make his home directory the path you want to
search, e.g.:

```bash
sudo useradd --badname --no-user-group --non-unique -u 1000 -g 1000 --shell /sbin/nologin -f0 -e0 --home-dir /home/zach/.local/scripts "~"
```

[stack overflow link](https://unix.stackexchange.com/questions/658031/how-do-i-make-a-shortcut-to-a-path-using-two-tilde-characters-or-similar/658158#658158)
