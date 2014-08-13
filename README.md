iPlayer4
========

buildroot-2014.05

Directory "buildroot-2014.05" contains all the scripts needed to build iPlayer4
Linux OS image (bootloader, kernel, rootfilesystem, applications).
To build Linux OS image go to "buildroot-2014.05" directory and type:
 make iPlayer4_BB_defconfig
 make
The Buildroot tool will load settings for iPlayer4 based on BeagleBone platform
and start the build process. For other HW iPlayer4 platforms check the
"buildroot-2014.05/configs" directory.
After build is finished resulting images are available at the
"buildroot-2014.05/output/images/" directory.
