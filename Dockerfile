FROM debian:bookworm

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y chromium
RUN apt-get install -y xserver-xorg-core xserver-xorg-video-fbdev x11-xserver-utils libgl1-mesa-dri  \
    xserver-xorg-video-vesa xautomation xauth xinit x11vnc feh matchbox-window-manager procps gawk  \
    dbus-x11 xserver-xorg-video-dummy x11-apps xterm

# black wallpaper
COPY wallpaper.png /etc/wallpaper.png

COPY entrypoint.sh /entrypoint.sh
COPY start_chromium.sh /start_chromium.sh

RUN chmod a+rwx /start_chromium.sh

ENTRYPOINT [ "/entrypoint.sh", "/start_chromium.sh"]
