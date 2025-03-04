set tabstop=4
set shiftwidth=0
set linebreak
set number
set clipboard=unnamedplus
set mouse=

color vim
set notermguicolors

function ToggleColorScheme()
	let theme=system('gsettings get org.gnome.desktop.interface gtk-theme')
	if theme =~ "[Dd]ark"
		set background=dark
	else
		set background=light
	endif
	redraw
endfunction

autocmd Signal SIGUSR1 call ToggleColorScheme()
