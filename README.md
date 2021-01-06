# GNU/Linux Boot Environments Gentoo overlay

## Installation

### Add the repository

Use [Layman](https://wiki.gentoo.org/wiki/Layman):
```
yes | layman -a linux-be
```

### Adjust the `portage` configuration

Set the required useflags and accept the keywords:
```
installed_overlay="$(portageq get_repo_path / linux-be)"

mkdir -p /etc/portage/package.use
ln -s "$installed_overlay"/Documentation/package.use/linux-be.use /etc/portage/package.use/

mkdir -p /etc/portage/package.accept_keywords
ln -s "$installed_overlay"/Documentation/package.accept_keywords/linux-be.keywords /etc/portage/package.accept_keywords/
```

To use the stand-alone `beadm` ebuild (for any version of ZFS):
```
ln -s "$installed_overlay"/Documentation/package.accept_keywords/beadm.keywords /etc/portage/package.accept_keywords/
```

To use the releases of `zfs` with `beadm` based on ZFSonLinux 0.8.x:
```
ln -s "$installed_overlay"/Documentation/package.accept_keywords/linux-be-zfs-0.8.keywords /etc/portage/package.accept_keywords/
```

Live `zfs*` ebuilds are also provided for testing untagged commits.

To use live `zfs*` ebuilds that fetch code from the `beadm` branch (based on `zfsonlinux/zfs` `zfs-0.8-release` branch):
```
ln -s "$installed_overlay"/Documentation/package.accept_keywords/linux-be-zfs-0.8.9999.keywords /etc/portage/package.accept_keywords/
```

### Install all the packages

```
emerge -avt {beadm,grub,genkernel,bemerge}::linux-be
```

or:

```
emerge -avt {zfs{,-kmod},grub,genkernel,bemerge}::linux-be
```

### Finish the installation

See [Installing linux-be](https://gitlab.com/linux-be/zfs/wikis/linux-be-installation/Installing-linux-be).
