You can build these isos if you have the right version of Archiso.

Archiso is a package supplied by Arch Linux that is recently undergoing some major changes.

You can follow up the versions via this link.

https://www.archlinux.org/packages/extra/any/archiso/

We are now using archiso version **58-1**

To know your version:

```
sudo pacman -Q archiso
```

If you have a higher version you can downgrade to this version:

```
downgrade archiso
```

and choose the right version. 

Add it to the ignore list of pacman.

If you have a lower version then update your system.

Check to see if archiso is not added to your /etc/pacman.conf file, in the list of ignores.

Delete it if this is the case. Then update your system.
