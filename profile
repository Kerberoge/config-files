if [[ $XDG_VTNR == 1 && -z $WAYLAND_DISPLAY ]]; then
	exec sway
else
	. ~/.bashrc
fi
