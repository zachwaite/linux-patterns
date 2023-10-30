# Resize the root partition of Ubuntu 20.04 with an lvm partition

[https://askubuntu.com/questions/1269603/resize-the-root-partition-of-ubuntu-20-04-with-an-lvm-partition](https://askubuntu.com/questions/1269603/resize-the-root-partition-of-ubuntu-20-04-with-an-lvm-partition)

Direct quote from the accepted stackoverflow answer:

> The solution provided in the link Riad shared worked for me. However, I'm
> summing up the steps here in case the link breaks:
>
> 1. use df -h /home/ or df -lh / to check your filesystem space and name. There
>    you can see if there is still space, the name of the mount, etc.
>
> 2. use vgdisplay <thevgname> to display the volume name and details. There you
>    can see VG size (total size), Allocated (used) and Free space. The free
>    space hints on how much you could expand your partition.
>
> 3. use lvextend -L +2G /thename/of/filesystem to extend the size the
>    partition. In this example it was increased by 2Gb... edit this part
>    according to your needs.
>
> 4. the, use resize2fs /thename/of/filesystem to actually expand the used
>    space.
>
> 5. check again with df -l to see the changes done.
>
> Addendum:
>
> Doing similar stuff (resizing, etc) I stumbled with another case, where cfdisk
> and lsblk did show that my /sda3 had enough size, but happened that my
> Physical Volume (PV) still needed to be resized.
>
> For that this answer helped me, which suggested to do:
>
> ```
> sudo psv
> ```
>
> To find the PV name (like /dev/sd3), and then resize it using sudo pvresize
> /dev/sda3. Modify according to your needs and volume names. I then was able to
> continue with the steps listed on this answer and proceed with lvextend and
> later resize2fs
