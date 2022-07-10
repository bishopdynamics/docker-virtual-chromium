#!/bin/bash
# chromium kiosk
set -x

############## Environment variables ##################
URL="${URL:-http://wikipedia.com}"  # url to load chromium with
WINDOW_WIDTH="${WINDOW_WIDTH:-800}"  # Window Width
WINDOW_HEIGHT="${WINDOW_HEIGHT:-600}"  # Window Height
SCALE="${SCALE:-1.0}"  # scale for chromium to render pages
EXTRA_CHROMIUM_ARGS="${EXTRA_CHROMIUM_ARGS:-}"  # additional arguments to pass chromium
CHROMIUM_DEBUG_PORT="${CHROMIUM_DEBUG_PORT:-9222}"  # port for chromium remote developer tools

############## Hardcoded variables ##################
USER_DATA_DIR="/config"  # static place for chromium user data folder. mount a volume here to persist cookies, history, preferences
WINDOW_POSITION="0,0"  # always want window to start at 0,0
DISK_CACHE_DIR="/dev/null"  # prevent chromium from caching anything

############## Functions ##################

function kill_pids() {
  # kill -TERM, then wait, for a list of pids in the order given
  for THIS_PID in "$@"; do
    if [ -n "$THIS_PID" ]; then
      echo "killing process: ${THIS_PID}..." >&2
      kill -TERM "$THIS_PID" && wait "$THIS_PID"
    fi
  done
}

function _kill_chromium() {
	# handler for killing off chromium when signal is caught
	#   TODO we should also do the xdotool thing like firefox_wrapper does, to cleanly stop the app
	echo "signal caught by chromium wrapper, cleaning up chromium" >&2
	kill_pids "$PID_CHROMIUM"
	echo "done cleaning up chromium" >&2
	exit 0
}

############## Actual startup begins here ##################

trap _kill_chromium SIGTERM SIGINT

echo ""
echo "starting chromium with url: $URL"

# this is the stupid lockfile chromium leaves behind when it doesnt get shut down properly
rm ${USER_DATA_DIR}/SingletonLock

CHROMIUM_CMD="chromium \
	--no-gpu \
	--disable-gpu \
	--no-sandbox \
	--autoplay-policy=no-user-gesture-required \
	--use-fake-ui-for-media-stream \
	--use-fake-device-for-media-stream \
	--disable-sync \
	--remote-debugging-port=$CHROMIUM_DEBUG_PORT \
	--display=$DISPLAY \
	--force-device-scale-factor=$SCALE \
	--window-size=${WINDOW_WIDTH},${WINDOW_HEIGHT} \
	--window-position=$WINDOW_POSITION \
	--pull-to-refresh=1 \
	--disable-smooth-scrolling \
	--disable-login-animations \
	--disable-modal-animations \
	--noerrdialogs \
	--no-first-run \
	--disable-infobars \
	--fast \
	--fast-start \
	--disable-pinch \
	--overscroll-history-navigation=0 \
	--disable-translate \
	--disable-overlay-scrollbar \
	--disable-features=OverlayScrollbar \
	--disable-features=TranslateUI \
	--disk-cache-dir=$DISK_CACHE_DIR \
	--password-store=basic \
	--touch-events=enabled \
	--ignore-certificate-errors \
	--user-data-dir=$USER_DATA_DIR \
	--kiosk $EXTRA_CHROMIUM_ARGS \
	--app=$URL"

echo ""
echo "running chromium command: $CHROMIUM_CMD"
echo ""
$CHROMIUM_CMD & PID_CHROMIUM=$!

echo ""
echo "######## Chromium has been started  #########"
echo ""

wait $PID_CHROMIUM

