export PATH=~/.local/bin:$PATH
export XDG_RUNTIME_DIR=/run/user/1000

if [ $(tty) = "/dev/tty2" -a -z $WAYLAND_DISPLAY ]; then
	cmd="exec dwl < <(status-line) >/dev/null 2>&1"
	exec dbus-run-session bash -c "$cmd" >/dev/null 2>&1
else
	. ~/.bashrc
fi
