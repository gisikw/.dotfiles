# Set mouse acceleration and disable secondary keys for Logitech Marble Mouse
which xset >/dev/null && xset m 3/2 0
MOUSE=$(xinput list | grep "Logitech USB Trackball" | sed 's/.*id=\([[:digit:]]\+\).*/\1/')
if [ -z "$MOUSE" ]; then
  xinput set-button-map $MOUSE 1 0 3
fi
