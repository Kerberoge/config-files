/* Super simple reboot program */
#include <stdio.h>
#include <unistd.h>
#include <linux/reboot.h>
#include <sys/reboot.h>

int main() {
	sync();
	printf("Rebooting ...\n");
	reboot(LINUX_REBOOT_CMD_RESTART);
	return 0;
}
