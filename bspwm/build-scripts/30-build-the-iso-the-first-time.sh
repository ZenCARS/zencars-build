#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxiso.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#Setting variables
#Let us change the name"
#First letter of desktop small

build_bare="-bare"

desktop="bspwm"
xdesktop="bspwm"

buildFolder="$HOME/zencars-build"
outFolder="$HOME/ZenCARS-Out"

#build.sh
oldname1="iso_name=zencars"
newname1="iso_name=zencars-$desktop"

oldname2='iso_label="zencars'
newname2='iso_label="zencars-'$desktop

#os-release
oldname3='NAME="ZenCARS"'
newname3='NAME=ZenCARS-'$desktop

oldname4='ID=ZenCARS'
newname4='ID=ZenCARS-'$desktop

#lsb-release
oldname5='DISTRIB_ID=ZenCARS'
newname5='DISTRIB_ID=ZenCARS-'$desktop

oldname6='DISTRIB_DESCRIPTION="ZenCARS"'
newname6='DISTRIB_DESCRIPTION=ZenCARS-'$desktop

#hostname
oldname7='ZenCARS'
newname7='ZenCARS-'$desktop

#hosts
oldname8='ZenCARS'
newname8='ZenCARS-'$desktop

#lightdm.conf user-session
oldname9='user-session=xfce'
newname9='user-session='$xdesktop

#lightdm.conf autologin-session
oldname10='#autologin-session='
newname10='autologin-session='$xdesktop

#dev-rel/efi-entries
oldname11='ZenCARS'
newname11='ZenCARS-'$desktop

echo
echo "################################################################## "
tput setaf 2;echo "Phase 1 : clean up and download the latest ZenCARS-iso from github";tput sgr0
echo "################################################################## "
echo
echo "Deleting the work folder if one exists"
[ -d ../work ] && sudo rm -rf ../work
echo "Deleting the build folder if one exists - takes some time"
[ -d $buildFolder ] && sudo rm -rf $buildFolder
echo "Git cloning files and folder to work folder"
git clone https://github.com/ZenCARS/zencars-iso ../work

echo
echo "################################################################## "
tput setaf 2;echo "Phase 2 : Getting the latest versions for some important files";tput sgr0
echo "################################################################## "
echo
echo "Removing the old packages.x86_64 file from work folder"
rm ../work/archiso/packages.x86_64
echo "Copying the new packages$build_bare.x86_64 file"
cp -f "../archiso/packages$build_bare.x86_64" ../work/archiso/packages.x86_64

echo "Removing old files/folders from /etc/skel"
rm -rf ../work/archiso/airootfs/etc/skel/.* 2> /dev/null

echo "getting .bashrc and .profile from zencars-root"
wget https://raw.githubusercontent.com/ZenCARS/zencars-root/master/.bashrc-latest -O ../work/archiso/airootfs/etc/skel/.bashrc
wget https://raw.githubusercontent.com/ZenCARS/zencars-root/master/.profile -O ../work/archiso/airootfs/etc/skel/.profile

echo
echo "################################################################## "
tput setaf 2;echo "Phase 3 : Renaming the ZenCARS iso";tput sgr0
echo "################################################################## "
echo
echo "Renaming to "$newname1
echo "Renaming to "$newname2
echo
sed -i 's/'$oldname1'/'$newname1'/g' ../work/archiso/build.sh
sed -i 's/'$oldname2'/'$newname2'/g' ../work/archiso/build.sh
sed -i 's/'$oldname3'/'$newname3'/g' ../work/archiso/airootfs/etc/os-release
sed -i 's/'$oldname4'/'$newname4'/g' ../work/archiso/airootfs/etc/os-release
sed -i 's/'$oldname5'/'$newname5'/g' ../work/archiso/airootfs/etc/lsb-release
sed -i 's/'$oldname6'/'$newname6'/g' ../work/archiso/airootfs/etc/lsb-release
sed -i 's/'$oldname7'/'$newname7'/g' ../work/archiso/airootfs/etc/hostname
sed -i 's/'$oldname8'/'$newname8'/g' ../work/archiso/airootfs/etc/hosts
sed -i 's/'$oldname9'/'$newname9'/g' ../work/archiso/airootfs/etc/lightdm/lightdm.conf
sed -i 's/'$oldname10'/'$newname10'/g' ../work/archiso/airootfs/etc/lightdm/lightdm.conf

sed -i 's/'$oldname11'/'$newname11'/g' ../work/archiso/airootfs/etc/dev-rel
sed -i 's/'$oldname11'/'$newname11'/g' ../work/archiso/efiboot/loader/entries/archiso-x86_64-cd.conf
sed -i 's/'$oldname11'/'$newname11'/g' ../work/archiso/efiboot/loader/entries/archiso-x86_64-usb.conf
sed -i 's/'$oldname11'/'$newname11'/g' ../work/archiso/syslinux/archiso_head.cfg
sed -i 's/'$oldname11'/'$newname11'/g' ../work/archiso/syslinux/archiso_pxe.cfg
sed -i 's/'$oldname11'/'$newname11'/g' ../work/archiso/syslinux/archiso_sys.cfg

echo
echo "################################################################## "
tput setaf 2;echo "Phase 4 : Checking if archiso is installed";tput sgr0
echo "################################################################## "
echo

package="archiso"

#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then

		echo "################################################################"
		echo "################## "$package" is already installed"
		echo "################################################################"

else

	#checking which helper is installed
	if pacman -Qi yay &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with yay"
		echo "################################################################"
		yay -S --noconfirm $package

	elif pacman -Qi trizen &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with trizen"
		echo "################################################################"
		trizen -S --noconfirm --needed --noedit $package

	fi

	# Just checking if installation was successful
	if pacman -Qi $package &> /dev/null; then

		echo "################################################################"
		echo "#########  "$package" has been installed"
		echo "################################################################"

	else

		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo "!!!!!!!!!  "$package" has NOT been installed"
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		exit 1
	fi

fi

echo
echo "################################################################## "
tput setaf 2;echo "Phase 5 : Moving files to build folder";tput sgr0
echo "################################################################## "
echo

echo "Copying files and folder to build folder as root"
sudo mkdir $buildFolder
sudo cp -r ../work/* $buildFolder

sudo chmod 750 ~/zencars-build/archiso/airootfs/etc/sudoers.d
sudo chmod 750 ~/zencars-build/archiso/airootfs/etc/polkit-1/rules.d
sudo chgrp polkitd ~/zencars-build/archiso/airootfs/etc/polkit-1/rules.d

cd $buildFolder/archiso

echo
echo "################################################################## "
tput setaf 2;echo "Phase 6 : Cleaning the cache";tput sgr0
echo "################################################################## "
echo

yes | sudo pacman -Scc

echo
echo "################################################################## "
tput setaf 2;echo "Phase 7 : Building the iso";tput sgr0
echo "################################################################## "
echo

sudo ./build.sh -v

echo
echo "################################################################## "
tput setaf 2;echo "Phase 8 : Moving the iso to out folder";tput sgr0
echo "################################################################## "
echo

[ -d $outFolder ] || mkdir $outFolder
cp $buildFolder/archiso/out/zencars* $outFolder

echo
echo "################################################################## "
tput setaf 2;echo "Phase 9 : Making sure we start with a clean slate next time";tput sgr0
echo "################################################################## "
echo
echo "Deleting the build folder if one exists - takes some time"
[ -d $buildFolder ] && sudo rm -rf $buildFolder
