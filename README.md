# ISO Sources

This is where you decide what you add in your live distribution, what tools, what packages, what configurations.

It contains only files and folders that are different from the official archiso.

These files and folders are located in the ./custom folder.

# Before building a custom ISO
To build the custom Iso you need to install **archiso** package:

```
sudo pacman -S archiso
```

Next, check out the archiso.md and use the same version of archiso.

If needed, downgrade to the right version:

```
downgrade archiso
```

and choose the correct one.

# Build
Simply run the **buildIso.sh** script in root:
```
sudo sh buildIso.sh
```

and go drink a coffee!