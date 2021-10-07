#! /bin/bash

#configuration
mail_address=root

#check packages
echo "downloading the packages with pacman..."
pacman_log=$(pacman -Syu --noconfirm --noprogressbar --downloadonly --quiet)
echo "$pacman_log"
echo "listing  packages ready for install..."
pacman_packages=$(pacman -Qu)
echo "$pacman_packages"

#compare with recent result
if [ "$pacman_packages" == "" ]; then
    
	echo "no updates available"

elif [ ! -f /var/log/archm-pacman-packages.log ] || [ "$(cat /var/log/archm-pacman-packages.log)" != "$pacman_packages" ]; then

	#sending out mail
	hostname=$(cat /etc/hostname)
	mail_header="Subject: Packages ready for install on:$hostname\n\r\n\r"
	mail_body="The following packages are downloaded and ready install:\n\r\n\r"$pacman_packages
	printf "$mail_header$mail_body" | sendmail "$mail_address"
	
	#update revision file
	echo "$pacman_packages" > /var/log/archm-pacman-packages.log
	
else

	echo "no changes"

fi




