# Chromium Virtual Display Container

Run Chromium in a virtual display in a docker container, and access it via VNC.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

# Files

Files
* [`Dockerfile`](Dockerfile) - container for running this
* [`docker-compose.yml`](docker-compose.yml) - example compose file
* [`entrypoint.sh`](entrypoint.sh) - takes care of virtual display
* [`start_chromium.sh`](start_chromium.sh) - starts the chromium instance in fullscreein kiosk-mode on the virtual display
* `wallpaper.png` - black wallpaper, so the screen goes black if the app quits

Dev scripts:
* [`build.sh`](build.sh) - build the container image
* [`deploy.sh`](deploy.sh) - deploy using [`docker-compose.yml`](docker-compose.yml)
* [`stop.sh`](stop.sh) - stop what you started
* [`test.sh`](test.sh) - run the instance from [`docker-compose.yml`](docker-compose.yml) interactively, without detaching
  * if you pass any args, they will be passed to `/entrypoint.sh` instead of the default entrypoint
  * example: `./test.sh /usr/bin/xeyes -fg blue`
  * connect to it at: vnc://localhost:5901


## Environment Vars

Here are the environment vars that [`start_chromium.sh`](start_chromium.sh) uses, and their default values:
```bash
URL="http://wikipedia.com"  # url to load chromium with
WINDOW_WIDTH="800"  # Window Width
WINDOW_HEIGHT="600"  # Window Height
SCALE="1.0"  # scale for chromium to render pages
EXTRA_CHROMIUM_ARGS=""  # additional arguments to pass chromium
CHROMIUM_DEBUG_PORT="9222"  # port for chromium remote developer tools
```

## entrypoint.sh

The script `entrypoint.sh` takes a single argument: a command or script to run inside the virtual display.

It will create a virtual display with the user home folder mapped to `/config` 

Here are the environment vars that [`entrypoint.sh`](entrypoint.sh) uses, and their default values:
```bash
WINDOW_WIDTH="800"  # Window Width
WINDOW_HEIGHT="600"  # Window Height
VNC_PASSWORD="badpass"  # vnc password
VNC_PORT="5900"  # vnc port
EXTRA_VNC_ARGS=""  # additional arguments for x11vnc
EXTRA_X_ARGS=""  # additional arguments for X server
PUID="1000"  # User ID
PGID="1000"  # Group ID
VIRTUAL_VRAM="192000"  # need more vram for higher resolutions
REFRESH_RATE="60"  # hz, refresh rate, probably should stick with 60
RUNAS_ROOT="false"  # override to "true" to run as root instead of the non-root user
```

This script is intended to be re-usable, running anything in the virtual display.

More details in this repo: [https://github.com/bishopdynamics/docker-virtual-display](https://github.com/bishopdynamics/docker-virtual-display)
