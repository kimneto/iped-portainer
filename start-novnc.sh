#!/usr/bin/env bash
set -e

export DISPLAY="${DISPLAY:-:1}"
export RESOLUTION="${RESOLUTION:-1366x768x24}"

# Sobe o X virtual
Xvfb "${DISPLAY}" -screen 0 "${RESOLUTION}" &
sleep 1

# Desktop
startxfce4 &

# VNC (sem senha) e noVNC
x11vnc -display "${DISPLAY}" -forever -shared -nopw -rfbport 5901 -bg
websockify --web=/usr/share/novnc/ 0.0.0.0:6080 127.0.0.1:5901 &

# Se foi passado um comando, executa-o (ex.: iped-search)
if [ "$#" -gt 0 ]; then
  # roda em background para manter o container vivo
  "$@" &
fi

# Mantém o container em pé
tail -f /dev/null
