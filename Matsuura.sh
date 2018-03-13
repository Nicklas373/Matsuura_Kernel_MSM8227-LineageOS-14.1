#!/bin/bash
#
# Copyright 2018, Dicky Herlambang "Nicklas373" <herlambangdicky5@gmail.com>
#
# Matsuura Kernel Builder Script // Side Development of Mimori Kernel
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

#Logic Memory
CROSS_COMPILE_4="$HOME/arm-linux-androideabi-4.9/bin"
CROSS_COMPILE_5="$HOME/arm-linux-androideabi-5.x/bin"
kernel_zImage="arch/arm/boot/zImage"
kernel_source="$HOME/Matsuura-Kernel-Nicki"
kernel_zip="TEMP/Pre-built_ZIP/ZIP"
zImage="TEMP/modules/zImage"

#Logic Answer Memory
answer(){
A="1"
B="2"
C="Yes"
D="No"
}

#Kernel Builder
build(){
cp TEMP/Pre-built_ZIP/Template/Matsuura_Kernel.zip TEMP/Pre-built_ZIP/ZIP/Matsuura_Kernel.zip
cd $kernel_zip
unzip Matsuura_Kernel.zip
cd $kernel_source
mv TEMP/modules/zImage TEMP/Pre-built_ZIP/ZIP/tmp/kernel/boot.img-zImage
mv TEMP/modules TEMP/Pre-built_ZIP/ZIP/tmp
cd TEMP/Pre-built_ZIP/ZIP
rm Matsuura_Kernel.zip
zip -r Matsuura_Kernel *
rm -rfv META-INF
rm -rfv system
rm -rfv tmp
cd $kernel_source/TEMP/Pre-built_ZIP/ZIP
mv Matsuura_Kernel.zip $kernel_source/TEMP/Pre-built_ZIP/Sign/Matsuura_Kernel.zip
cd $kernel_source/TEMP/Pre-built_ZIP/Sign
java -jar signapk.jar signature-key.Nicklas@XDA.x509.pem signature-key.Nicklas@XDA.pk8 Matsuura_Kernel.zip Matsuura_Kernel-nicki-signed.zip
mv  Matsuura_Kernel-nicki-signed.zip $kernel_source/Build/Matsuura_Kernel-nicki-signed.zip
rm Matsuura_Kernel.zip
echo "Matsuura Kernel Completed to build"
echo "Thanks to XDA - Developers"
echo "プロジェクト　ラブライブ | Project Matsuura (2018)"
echo "ありがとう　ございます μ's !!!"
}

#Kernel Checking
checking(){
echo "Checking kernel..."
if [ -f "$zImage" ]
then
	echo "Kernel found"
	echo "Continue to build kernel"
	build
	message=${1:-"Riko's Piano Sonata"}
	notify-send -t 10000 -i TEMP/Additional/3.jpg "想いよひとつになれ (ピアノバージョン)" "$message"
	ffplay $kernel_source/TEMP/Additional/3.flac
	echo "Cleaning up"
	cd $kernel_source
	make clean && make mrproper
	exit
else
	echo "Kernel not found"
	echo "Cancel kernel to build"
	gedit matsuura.log
	cd $kernel_source
	message=${1:-"AZALEA"}
	notify-send -t 10000 -i TEMP/Additional/2.jpg "Tokimeki Bunruigaku" "$message"
	ffplay $kernel_source/TEMP/Additional/2.flac
	echo "Cleaning up"
	cd $kernel_source
	make clean && make mrproper
	echo "Try to fix error"
	exit
fi
}

#Kernel Modules GCC4
modules_gcc_4(){
echo "##Creating Temporary Modules kernel"
mkdir modules
cp $kernel_zImage modules
find . -name "*.ko" -exec cp {} modules \;
cd modules
$CROSS_COMPILE_4/arm-linux-androideabi-strip --strip-unneeded *.ko
cd $kernel_source
mv modules TEMP
}

#Kernel Modules GCC5
modules_gcc_5(){
echo "##Creating Temporary Modules kernel"
mkdir modules
cp $kernel_zImage modules
find . -name "*.ko" -exec cp {} modules \;
cd modules
$CROSS_COMPILE_5/arm-linux-androideabi-strip --strip-unneeded *.ko
cd $kernel_source
mv modules TEMP
}

#Invalid Option
invalid(){
echo "Your Option Is Invalid"
echo "Return to main menu ?"
echo "1. Yes"
echo "2. No"
echo "(Yes / No)"
read option
answer
if [ "$option" == "$C" ];
	then
		menu_compile
fi
if [ "$option" == "$D" ];
	then
		echo "See You Later"
		exit
fi
}

# Kernel Done (Only on Ubuntu WSL)
# finish(){
# cp Build/Mimori_Kernel-nicki-signed.zip /mnt/c/Users/Nickl/Downloads
# echo "Kernel already copied to outside from linux :)"
# }

#Main Program
menu_compile(){
echo "
######################################################
#                                                    #
#                   Matsuura Kernel                  #
#                                                    #
#                Nicklas Van Dam @XDA                #
#                                                    #
#	   PRIVATE DEVELOPMENT OF Mimori Kernel	     #
#						     #
######################################################"
echo "Welcome To Matsuura Kernel Builder"
echo "Select Which GCC To Use ?"
echo "1. GCC 4.9.X (Only for old build)"
echo "2. GCC 5.4.X"
echo "( 1 / 2)"
read choice
answer
if [ "$choice" == "$A" ];
	then
		echo "##Running GCC Toolchains 4.9 (Hyper Toolchains)"
		export ARCH=arm
		export CROSS_COMPILE=$CROSS_COMPILE_4/arm-linux-androideabi-
		echo "##Building Matsuura Kernel"
		make ARCH=arm matsuura_nicki_defconfig
		make ARCH=arm CROSS_COMPILE=$CROSS_COMPILE_4/arm-linux-androideabi- -j4 -> matsuura.log
		modules_gcc_4
		checking
		menu_compile
fi
if [ "$choice" == "$B" ];
	then
		echo "##Running GCC Toolchains 5.4 (Hyper Toolchains)"
		export ARCH=arm
		export CROSS_COMPILE=$CROSS_COMPILE_5/arm-linux-androideabi-
		echo "##Building Matsuura Kernel"
		make ARCH=arm matsuura_nicki_defconfig
		make ARCH=arm CROSS_COMPILE=$CROSS_COMPILE_5/arm-linux-androideabi- -j4 -> matsuura.log
		modules_gcc_5
		checking
	else
		invalid
fi
}

#Execute Program
menu_compile
