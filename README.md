# freebsd-ports-dank

![dank meme pic](https://unrelentingtech.s3.dualstack.eu-west-1.amazonaws.com/dankbsd.jpg?1)

Welcome!

This fork of the FreeBSD Ports Collection merges the [KDE](https://github.com/freebsd/freebsd-ports-kde) and [GNOME](https://github.com/freebsd/freebsd-ports-gnome) branches together with the upstream and adds more bleeding edge desktop-related patches.

## Usage

- Make sure you have an up-to-date FreeBSD 12-CURRENT kernel and base
- Clone this repo into `/usr/ports` (if it's already managed by git, add this repo as a remote, fetch and checkout/merge)
- Build any ports you want :)

## Current status

### Graphics stack

- `graphics/drm-next-kmod`: hack workaround patch for ioctl auth issues [kms-drm#33](https://github.com/FreeBSDDesktop/kms-drm/issues/33)
- `graphics/mesa-dev`: alternative mesa port! Development version ([little fork](https://github.com/myfreeweb/mesa) with my BSD patches), everything built together, using Meson! Always includes GL, GLES, Vulkan (RADV, ANV), Gallium Nine, OpenCL (Clover), VDPAU.
	- to install and keep pkg happy without rebuilding everything, just `pkg add -f` over existing `mesa-libs/dri`
	- but if you want to do it properly, define `MESA_DRI_PORT=graphics/mesa-dev` and `MESA_LIBS_PORT=graphics/mesa-dev` in `make.conf` and rebuild dependent ports
		- [synth](https://github.com/jrmarino/synth) is the recommended port upgrade tool, it does try to fetch binary packages when a rebuild is not necessary
- `graphics/libdrm`: 2.4.96 [231607](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=231607)

NOTE: ANV (Intel Vulkan) requires running the apps as root and might not work for complex applications.
RADV (Radeon Vulkan) with the `amdgpu` KMS/DRM driver works very well!
Tested on an AMD Polaris (RX 480) GPU.

### Desktop stack

- `devel/sdl20`: Wayland and udev options added [223018](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=223018)
- `devel/libevdev` / `devel/evdev-proto` / `devel/py-evdev`: 1.5.9 and stuff [217248](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=217248)
- `devel/libepoll-shim`: update version [223530](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=223530)
- `x11/libinput`: [222905](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=222905)
	- update to 1.10.4
	- fix [touchpad dropping out](https://blog.grem.de/pages/t470s.html)
	- fix device rejection when running without /dev/input access
- `x11-servers/xorg-server`:
	- add `UDEV` option to support evdev devices autodetection [222609](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=222609)
	- fix terminal handling without 'keyboard' driver [220562](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=220562)

#### Weston

A port for Weston is developed in [D10599](https://reviews.freebsd.org/D10599), but I use Weston directly from [my fork](https://github.com/myfreeweb/weston/commits/master).
It has a bit of extra crap beyond FreeBSD support (fractional HiDPI scaling, experimental bugfixes, static linking support for the [Rust bindings](https://github.com/myfreeweb/weston-rs) that are the basis of [a future desktop environment](https://github.com/myfreeweb/dankshell)), and it's master, not a release.

How to use Weston:

- Install Mesa with full Wayland support (`WAYLAND` option, or `mesa-dev` from here)
- Install `wayland-protocols` and `wayland` (newest, i.e. from here)
- Install libinput from here (because it has [a permission fix](https://github.com/myfreeweb/freebsd-ports-dank/blob/master/x11/libinput/files/patch-src_evdev.c.reopen) so you don't have to give yourself access to `/dev/tty*`, `/dev/input/*`, `/dev/dri/*`, `/dev/drm/*`)
- Install Weston from my fork
- Add yourself to the `weston-launch` group
- Make sure the `weston-launch` binary is suid and owned by root
- Make sure you have an `XDG_RUNTIME_DIR` in the environment
- Put your favorite keyboard settings into the environment e.g. `export XKB_DEFAULT_LAYOUT=us XKB_DEFAULT_VARIANT=colemak XKB_DEFAULT_MODEL=pc101 XKB_DEFAULT_RULES=evdev XKB_DEFAULT_OPTIONS="ctrl:nocaps,ctrl:lctrl_meta,compose:ralt,grp:alt_space_toggle"`
- Run `weston-launch`!

### Games

- `games/vcmi`: open source reimplementation of Heroes of Might and Magic III! [221885](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=221885)
- `games/freeminer`: update, luajit 2.1 fix [226537](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=226537)
- `games/minetest`: luajit 2.1 fix, clang fixes [226541](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=226541)
- `games/regoth`: [Gothic game engine reimplementation](https://github.com/REGoth-project/REGoth) (NOTE: [doesn't like mesa assertions which are ON in mesa-dev right now](https://bugs.archlinux.org/task/58218)) [227844](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=227844)

### Misc

- `net/qt5-network`: LibreSSL compat [228344](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=228344)
- `emulators/yuzu`: experimental Switch emulator [228487](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=228487)
- `graphics/hdrmerge`: HDR merge tool (git master qt5)
- `graphics/shaderc`: google's glslang-based thing, needed for vulkan support in mpv. Quite bad for packaging: [#424](https://github.com/google/shaderc/issues/424) [#381](https://github.com/google/shaderc/issues/381) [#392](https://github.com/google/shaderc/issues/392)
- `multimedia/mpv`: 0.28.2, vulkan
- `x11-toolkits/gtk40`: git master, vulkan, skip installing gschemas (fix parallel install w/ gtk3)
- `multimedia/shotcut`: 18.03.06
- `emulators/mesen`: a NES emulator [227351](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=227351)
- `games/retroarch`: 1.7.3, add WAYLAND option [227345](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=227345) (+ UDEV option but we don't have evdev gamepad drivers yet)
- `textproc/ibus`: add WAYLAND option (not actually used for toolkit based apps; also ibus's UI drawing is still X11 only)
- `mail/geary`: workaround for [Vala/gee array null termination bug](https://bugzilla.gnome.org/show_bug.cgi?id=794731)
- `graphics/simple-scan`: GNOME scanning app
- `devel/libgusb`: GObject libusb wrapper (w/ [PR #10](https://github.com/hughsie/libgusb/pull/10))
- `graphics/colord`: build vapi [227134](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=227134)
- `editors/abiword`: 3.0.2 [220975](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=220975)
- `sysutils/libcpuid`: git master
- `emulators/wine-devel`: WoW64 [D14721](https://reviews.freebsd.org/D14721), gallium nine patch (needs d3dadapter in i386 too?)
- `editors/gnome-latex`: renamed from `editors/latexila`, updated to 3.28.0 [226938](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=226938)
- `cad/solvespace`: git master (GTK3 HiDPI)
- `math/nasc`: dual pane text calculator similar to Soulver
- `graphics/akira`: VERY WIP (nothing works yet) UI design tool
- `x11/kitty`: GPU accelerated terminal emulator (note: terminfo)
- `security/gonepass`: 1Password vault reader [226706](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=226706)
- `audio/sonata`: update to git master (GTK3)
- `audio/clementine-player`: git qt5 branch
- `audio/liblastfm`: qt5 flavor for clementine [D14667](https://reviews.freebsd.org/D14667)
- `audio/libechonest`: qt5 flavor for clementine [226529](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=226529)
- `devel/geany`: GTK3 [226523](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=226523)
- `devel/sdl20`: 2.0.8 [226409](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=226409) (TEMPORARILY ROLLED BACK [#4109](https://bugzilla.libsdl.org/show_bug.cgi?id=4109))
- `lang/luajit`: update to 2.1.0-beta3 (works on arm64) [225342](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=225342)
- `multimedia/gnome-twitch`: Twitch livestream player [224980](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=224980)
- `archivers/maxcso`: ISO to CSO compressor for PSP/PS2 emulators [224638](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=224638)
- `graphics/mypaint` and `graphics/libmypaint`: git master version, works on Wayland natively
- `graphics/gimp-app` (& `graphics/gegl3`, `x11/babl`): git gtk3-port-meson version, works on Wayland natively (opening pngs seems to crash the plugin but selecting Proceed in console works and the file gets loaded o_0) (gimp plugin ports are probably screwed!)
- `graphics/inkscape`: git master version with GTK3, works on Wayland natively
- `editors/libreoffice`: GTK3 by default, works on Wayland natively
- `www/firefox`: (no extra updates here currently) See [FirefoxSettings](https://unrelenting.technology/kb/FirefoxSettings) for, well, settings (force enable GPU acceleration!)
- `java/jamvm`: update to 2.0.0 [192305](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=192305)
- `audio/rhythmbox-plugin-{alternative-toolbar,coverart-browser,coverart-search-providers}`: Some nice Rhythmbox plugins [223137](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=223137)
- `graphics/osg`: update to 3.6 [230442](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=230442)
- `www/epiphany`: use MSE if available
- `www/webkit2-gtk3`: option to enable MSE (note: broken with VP9 for now, youtube crashes)
- `graphics/rawtherapee`: disable mmap (to make performance over NFS not terrible), enable LTO
- `*/gstreamer1*`: update to 1.14.3 [231406](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=231406)
- `multimedia/pitivi`: update to 0.999
- `textproc/pict`: pairwise test gen tool [231407](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=231407)
- `lang/maude`: update to 2.7.1 [231443](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=231443)
- `net/libjson-rpc-cpp`: jsonrpc lib [231735](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=231735)
- `net-p2p/ethminer` (& `devel/ethash` `devel/cli11`): OpenCL miner - previous version since latest broke Clover support; even this one only works in test/benchmark mode for me currently
- `devel/mull`: mutation test framework

### Ports framework

- [D13078](https://reviews.freebsd.org/D13078) for gnome-twitch

## Kernel patches

- [222375](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=222375) linsysfs(5): Add support for recent libdrm [LANDED!](https://github.com/freebsd/freebsd/commit/09ad0b962f3029e47b3f430948933b6fe066ccdf)
- [222504](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=222504) Add support for 32-bit compatibility IOCTLs in the LinuxKPI [LANDED!](https://github.com/freebsd/freebsd/commit/10ef676c4bbe7379de1f3687444e4311a7d872e2)
- [222646](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=222646) ukbd(4): support Consumer Control based multimedia keys

## Recommended kernel config

`/usr/src/sys/amd64/conf/DESKTOP`:

```
include GENERIC-NODEBUG
ident   DESKTOP
device		evdev
options		EVDEV_SUPPORT
options 	KDTRACE_HOOKS
options 	VIMAGE
```

(the important part is the `EVDEV_SUPPORT`, which is still disabled by default for some reason!)

## Other FreeBSD desktop resources

- [kb/FreeBSDDesktop](https://unrelenting.technology/kb/FreeBSDDesktop)
- [My dotfiles](https://github.com/myfreeweb/dotfiles) (mostly the `x11` folder)
- [A FreeBSD 11 Desktop How-to](https://cooltrainer.org/a-freebsd-desktop-howto/), not up to date with modern GPU stuff but very good for general desktop setup (printing, networking, etc.)
- [FreeBSD on the ThinkPad X240](https://unrelenting.technology/articles/freebsd-on-the-thinkpad-x240), my post that's mostly updated but still contains old stuff

## Other resources

- [1.5 Hour Spicy SUPER EUROBEAT Mix](https://www.youtube.com/watch?v=6ftCIfHwqtg)
