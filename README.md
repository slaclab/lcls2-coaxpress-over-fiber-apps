# lcls2-coaxpress-over-fiber-apps

<!--- ######################################################## -->

# Before you clone the GIT repository

1) Create a github account:
> https://github.com/

2) On the Linux machine that you will clone the github from, generate a SSH key (if not already done)
> https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/

3) Add a new SSH key to your GitHub account
> https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/

4) Setup for large filesystems on github

```
$ git lfs install
```

5) Verify that you have git version 2.13.0 (or later) installed 

```
$ git version
git version 2.13.0
```

6) Verify that you have git-lfs version 2.1.1 (or later) installed 

```
$ git-lfs version
git-lfs/2.1.1
```

# Clone the GIT repository

```
$ git clone --recursive git@github.com:slaclab/lcls2-coaxpress-over-fiber-apps
```

<!--- ######################################################## -->

# Dual QSFP PCIe Card's Fiber mapping

```
QSFP[0][0] = CXPoF.Lane[0]
QSFP[0][1] = CXPoF.Lane[1]
QSFP[0][2] = CXPoF.Lane[2]
QSFP[0][3] = CXPoF.Lane[3]
QSFP[1][0] = LCLS-I  Timing Receiver
QSFP[1][1] = LCLS-II Timing Receiver
QSFP[1][2] = Unused QSFP Link
QSFP[1][3] = Unused QSFP Link
SFP = Unused SFP Link
```

<!--- ######################################################## -->

# DMA channel mapping

```
DMA.DEST[0] = SRPv3 for coaxpress camera configuration
DMA.DEST[1] = Event Builder Batcher (super-frame)
DMA.DEST[1].DEST[0] = XPM Trigger Message (sub-frame)
DMA.DEST[1].DEST[1] = XPM Transition Message (sub-frame)
DMA.DEST[1].DEST[2] = Camera Data Image (sub-frame)
DMA.DEST[1].DEST[3] = XPM Timing Message (sub-frame)
DMA.DEST[1].DEST[4] = Camera Header (sub-frame)
DMA.DEST[255:2] = Unused
```

<!--- ######################################################## -->

# Camera and Its Header Format

The SURF `CoaXPressRxHsFsm.vhd` firmware formats the camera header into a compact, 7 x 32-bit (little endianness) message.
Refer to [Table 47 ― Rectangular image header](http://jiia.org/wp-content/themes/jiia/pdf/standard_dl/coaxpress/CXP-001-2021.pdf)
for header term definations 

```
WORD[0]BIT[07:00] = StreamID
WORD[0]BIT[15:08] = Flags
WORD[0]BIT[31:16] = SourceTag

WORD[1]BIT[23:00] = Xsize
WORD[1]BIT[31:24] = 0x0 (zeros)

WORD[2]BIT[23:00] = Xoffs
WORD[2]BIT[31:24] = 0x0 (zeros)

WORD[3]BIT[23:00] = Ysize
WORD[3]BIT[31:24] = 0x0 (zeros)

WORD[4]BIT[23:00] = Yoffs
WORD[4]BIT[31:24] = 0x0 (zeros)

WORD[5]BIT[23:00] = DsizeL
WORD[5]BIT[31:24] = 0x0 (zeros)

WORD[6]BIT[15:00] = PixelF
WORD[6]BIT[31:16] = TapG
```


<!--- ######################################################## -->

# How to build the PCIe firmware

1) Setup Xilinx licensing
```
$ source lcls2-coaxpress-over-fiber-apps/firmware/setup_env_slac.sh
```

2) Go to the target directory and make the firmware:
```
$ cd lcls2-coaxpress-over-fiber-apps/firmware/targets/Lcls2CoaxpressOverFiberXilinxAlveoU200
$ make
```

3) Optional: Review the results in GUI mode
```
$ make gui
```

<!--- ######################################################## -->

# How to load the driver

```
# Confirm that you have the board the computer with VID=1a4a ("SLAC") and PID=2030 ("AXI Stream DAQ")
$ lspci -nn | grep SLAC
04:00.0 Signal processing controller [1180]: SLAC National Accelerator Lab TID-AIR AXI Stream DAQ PCIe card [1a4a:2030]

# Clone the driver github repo:
$ git clone --recursive https://github.com/slaclab/aes-stream-drivers

# Go to the driver directory
$ cd aes-stream-drivers/data_dev/driver/

# Build the driver
$ make

# Load the driver
$ sudo /sbin/insmod ./datadev.ko cfgSize=0x200000 cfgRxCount=4096 cfgTxCount=16

# Give appropriate group/permissions
$ sudo chmod 666 /dev/datadev*

# Check for the loaded device
$ cat /proc/datadev0

```

<!--- ######################################################## -->

# How to install the Rogue With Anaconda

> https://slaclab.github.io/rogue/installing/anaconda.html

<!--- ######################################################## -->

# XPM Triggering Documentation

https://docs.google.com/document/d/1B_sIkk9Fxsw2EjOBpGVFpfCCWoIiOJoVGTrkTshZfew/edit?usp=sharing

<!--- ######################################################## -->

# How to reprogram the PCIe firmware via Rogue software

1) Setup the rogue environment
```
$ cd lcls2-coaxpress-over-fiber-apps/software
$ source setup_env_slac.sh
```

2) Run the PCIe firmware update script:
```
$ python scripts/updatePcieFpga.py --path <PATH_TO_IMAGE_DIR>
```
where <PATH_TO_IMAGE_DIR> is path to image directory (example: ../firmware/targets/Lcls2CoaxpressOverFiberXilinxAlveoU200/images/)

3) Reboot the computer
```
sudo reboot
```

<!--- ######################################################## -->

# How to run the Rogue PyQT GUI

1) Setup the rogue environment
```
$ cd lcls2-coaxpress-over-fiber-apps/software
$ source setup_env_slac.sh
```

2) Lauch the GUI:
```
$ python scripts/devGui.py
```

# Example of starting up in stand alone mode (locally generated timing)
```
$ python scripts/devGui.py --standAloneMode 1
Then execute the StartRun() command to start the triggering
```

<!--- ######################################################## -->
