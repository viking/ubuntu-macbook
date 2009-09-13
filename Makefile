init: fix-airport fix-capslock-led fix-isight fix-touchpad fix-eject-key fix-suspending fix-brightness-keys set-minimum-fan-speed set-laptop-mode disable-touchpad-while-typing

fix-airport:
	sudo apt-get install linux-backports-modules-jaunty

fix-capslock-led:
	sudo apt-get remove mouseemu

fix-isight:
	sudo mkdir -p /MacOSX
	sudo mount -t hfsplus /dev/sda2 /MacOSX	
	sudo apt-get install cheese isight-firmware-tools
	sudo umount /MacOSX
	# see https://bugs.edge.launchpad.net/ubuntu/+source/cheese/+bug/345080/comments/15
	sudo apt-get build-dep libv4l-0
	if [ \! -e tmp/libv4l-0.5.99 ]; then \
	  mkdir -p tmp && \
	  cd tmp && \
	  wget http://people.atrpms.net/~hdegoede/libv4l-0.5.99.tar.gz && \
	  tar xzf libv4l-0.5.99.tar.gz && \
	  cd libv4l-0.5.99 && \
	  make && \
	  sudo make install PREFIX=/usr; \
	fi

fix-touchpad:
	sudo apt-get install xserver-xorg-input-synaptics
	sudo cp etc/hal/fdi/policy/appletouch.fdi /etc/hal/fdi/policy

fix-eject-key:
	sudo cp etc/hal/fdi/policy/eject.fdi /etc/hal/fdi/policy

fix-suspending:
	sudo cp etc/pm/sleep.d/99-macbook.sh /etc/pm/sleep.d

fix-brightness-keys:
	if [ -e ~/.config/autostart ]; then \
	  cp .config/autostart/brightness-keys.desktop ~/.config/autostart; \
	fi

set-minimum-fan-speed:
	if [ `grep applesmc /etc/modules | wc -l` -eq 0 ]; then \
	  sudo modprobe applesmc && \
	  echo applesmc | sudo tee -a /etc/modules; \
	fi
	sudo sh -c 'echo 3000 > /sys/devices/platform/applesmc.768/fan1_min'

set-laptop-mode:
	sudo /etc/init.d/laptop-mode start	
	sudo sed -i 's/ENABLE_LAPTOP_MODE=false/ENABLE_LAPTOP_MODE=true/' /etc/default/acpi-support

disable-touchpad-while-typing:
	sudo cp etc/hal/fdi/policy/shmconfig.fdi /etc/hal/fdi/policy
	if [ -e ~/.config/autostart ]; then \
	  cp .config/autostart/syndaemon.desktop ~/.config/autostart; \
	fi
