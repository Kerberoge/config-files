#!/bin/sh

(
	/usr/libexec/virtiofsd \
		--socket-path=/run/user/1000/virtiofsd \
		--shared-dir=$HOME/virt/shared \
		--cache=always >/dev/null 2>&1
	rm /run/user/1000/virtiofsd*
) &

cd ~/virt
qemu-system-x86_64 \
		-nodefaults \
		-display gtk,show-cursor=on \
		-vga qxl \
		-monitor vc \
		-enable-kvm \
		-cpu host \
		-smp 4 \
		-m 4G \
		-drive file=virtio-win-0.1.262.iso,media=cdrom \
		-drive file=windows.img,if=virtio,format=raw \
		-net nic,model=virtio-net-pci \
		-net user \
		-audio pipewire,model=hda \
		-device qemu-xhci,id=xhci \
		-device usb-tablet \
		$(: -device usb-host,bus=xhci.0,vendorid=0x0451,productid=0xe008) \
		-chardev socket,id=char0,path=/run/user/1000/virtiofsd \
		-device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=Shared \
		-object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on \
		-numa node,memdev=mem \
		"$@" &
