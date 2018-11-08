#Menu tools use this value to decide which applications
# are approriate for the current session.
if [ -z $XDG_CURRENT_DESKTOP ]; then
  export XDG_CURRENT_DESKTOP="GNOME-Flashback:GNOME"
fi


# Run gnome-session and tell it to use our i3 session.
exec gnome-session --session=gnome-plus-i3 --disable-acceleration-check 

#exec i3 --force-xinerama -V >>~/.i3/i3log 2>&1

