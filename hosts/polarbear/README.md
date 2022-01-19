# PolarBear

Personal desktop computer running dwm or awesomewm

```shell
▸ nix-shell -p pkgs.inxi -p pkgs.lm_sensors --command "inxi -Fx"
System:    Host: nixos Kernel: 5.13.11 x86_64 bits: 64 compiler: gcc v: 10.3.0 Desktop: N/A Distro: NixOS 21.11 (Porcupine)
Machine:   Type: Desktop Mobo: Gigabyte model: Z97X-UD5H-BK serial: <superuser required> UEFI: American Megatrends v: F8
           date: 09/19/2015
CPU:       Info: Quad Core model: Intel Core i7-4790K bits: 64 type: MT MCP arch: Haswell rev: 3 cache: L2: 8 MiB
           flags: avx avx2 lm nx pae sse sse2 sse3 sse4_1 sse4_2 ssse3 vmx bogomips: 63857
           Speed: 4391 MHz min/max: 800/4400 MHz Core speeds (MHz): 1: 4391 2: 4390 3: 4390 4: 4390 5: 4390 6: 4390 7: 4390
           8: 4390
Graphics:  Device-1: Intel Xeon E3-1200 v3/4th Gen Core Processor Integrated Graphics vendor: Gigabyte driver: i915 v: kernel
           bus-ID: 00:02.0
           Device-2: NVIDIA GM204 [GeForce GTX 970] vendor: Gigabyte driver: nouveau v: kernel bus-ID: 01:00.0
           Display: x11 server: X.Org 1.20.13 driver: loaded: nouveau note: n/a (using device driver)
           resolution: 3840x2160~60Hz
           Message: Unable to show advanced data. Required tool glxinfo missing.
Audio:     Device-1: Intel Xeon E3-1200 v3/4th Gen Core Processor HD Audio driver: snd_hda_intel v: kernel bus-ID: 00:03.0
           Device-2: Intel 9 Series Family HD Audio vendor: Gigabyte driver: snd_hda_intel v: kernel bus-ID: 00:1b.0
           Device-3: NVIDIA GM204 High Definition Audio vendor: Gigabyte driver: snd_hda_intel v: kernel bus-ID: 01:00.1
           Sound Server-1: ALSA v: k5.13.11 running: yes
           Sound Server-2: PulseAudio v: 14.2-rebootstrapped running: yes
Network:   Device-1: Intel Ethernet I217-V vendor: Gigabyte driver: e1000e v: kernel port: f080 bus-ID: 00:19.0
           IF: eno1 state: up speed: 1000 Mbps duplex: full mac: 74:d4:35:ed:20:3d
           Device-2: Qualcomm Atheros Killer E220x Gigabit Ethernet vendor: Gigabyte driver: alx v: kernel port: d000
           bus-ID: 03:00.0
           IF: enp3s0 state: down mac: 74:d4:35:ed:20:51
           Device-3: Broadcom BCM4360 802.11ac Wireless Network Adapter vendor: Apple driver: wl v: kernel port: d000
           bus-ID: 06:00.0
           IF: wlp6s0 state: dormant mac: 42:9b:fa:80:1f:d6
           IF-ID-1: virbr0 state: up speed: 10 Mbps duplex: unknown mac: 52:54:00:92:8e:fe
           IF-ID-2: vnet1 state: unknown speed: 10 Mbps duplex: full mac: fe:54:00:89:0c:aa
Bluetooth: Device-1: Apple Bluetooth USB Host Controller type: USB driver: btusb v: 0.8 bus-ID: 2-8.3:8
           Report: rfkill ID: hci0 rfk-id: 1 state: up address: see --recommends
Drives:    Local Storage: total: 1.83 TiB used: 36.51 GiB (1.9%)
           ID-1: /dev/sda vendor: Samsung model: SSD 840 PRO Series size: 476.94 GiB
           ID-2: /dev/sdb vendor: Western Digital model: WD15EZRX-00DC0B0 size: 1.36 TiB
Partition: ID-1: / size: 460.02 GiB used: 36.48 GiB (7.9%) fs: ext4 dev: /dev/sda1
           ID-2: /boot size: 510 MiB used: 28.7 MiB (5.6%) fs: vfat dev: /dev/sda3
Swap:      ID-1: swap-1 type: partition size: 8 GiB used: 0 KiB (0.0%) dev: /dev/sda2
Sensors:   System Temperatures: cpu: 29.8 C mobo: 27.8 C gpu: nouveau temp: 37.0 C
           Fan Speeds (RPM): N/A gpu: nouveau fan: 1621
Info:      Processes: 269 Uptime: 7h 06m Memory: 31.18 GiB used: 5.82 GiB (18.7%) Init: systemd Compilers: gcc: 10.3.0
           Packages: 1795 Shell: Bash v: 4.4.23 inxi: 3.3.04

▸ lsblk -f
NAME   FSTYPE FSVER LABEL  UUID                                 FSAVAIL FSUSE% MOUNTPOINT
sda
├─sda1 ext4   1.0   nixos  f78ed0eb-2204-49e6-96ee-202e26b682f7  400.1G     8% /
├─sda2 swap   1     swap   4e4631f9-c205-49d9-baad-7a2549b735a4                [SWAP]
└─sda3 vfat   FAT32 boot   6C33-8E8A                             481.3M     6% /boot
sdb
└─sdb1 ext4   1.0   Backup 754ddd2c-184e-43f4-9c6b-266a5eda7650
sr0

```
