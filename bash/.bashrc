export EDITOR=nvim
export HISTSIZE=10000

alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias fastfetch='fastfetch --color "38;5;2" --logo-color-2 "38;5;8"'
alias record='wf-recorder -a --audio-backend=pipewire -c h264_vaapi \
	-F eq=gamma=1,hwupload,scale_vaapi=format=nv12 -f'
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'
alias cn='ssh joe@dogespace.nl -p 1983'

PS1="\[\e[1;38;5;2m\]\h\[\e[0m\]:\[\e[1;38;5;3m\]\w\[\e[0m\] \\$ "
