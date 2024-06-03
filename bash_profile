export PATH=~/.local/bin:$PATH

if [[ $(tty) == "/dev/tty2" && -z $WAYLAND_DISPLAY ]]; then
	export XDG_RUNTIME_DIR=/run/user/1000
	exec dbus-run-session dwl >/dev/null 2>&1
else
	. ~/.bashrc
fi
