#! /bin/bash

inp=$1
inp_ct=$#
#echo "Count of args is: $inp_ct"

chk_clock=`sudo cat /sys/class/drm/card0/device/power_dpm_force_performance_level`
speed=`sudo cat /sys/class/drm/card0/device/pp_dpm_sclk | sed -e 's/^.*[^\*]$//g' | sed -r '/^[[:space:]]*$/d' | sed -E 's/^[0-9]+:\ //g' | sed -E 's/[^[:digit:]]//g'`

: '
* NOTE:
* 
* Recommended clock state is between 3 and 5 for regular use.
* 
* 4 was originally used, since it was basically right
* in the middle, but 3 should be fine for 95% of my personal
* use cases.
* 
* NOTE:
* All the above recommended numbers were 1 lower, but
* the script requires them to have been upped -- 4 was 3,
* "3 to 5" was "2 to 4".
* 
* This was due to the indexes added later.
'
#Set the desired clock state
sclk_def=3 #Change this default to desired clock state
speeds=`sudo cat /sys/class/drm/card0/device/pp_dpm_sclk |  sed -r '/^[[:space:]]*$/d' | sed -E 's/^[0-9]+:\ //g' | sed -E 's/[^[:digit:]]//g'`
count=`echo $speeds | awk '{ print NF }'`

if [ $inp_ct -gt 0 ]
then
	if [ $inp -lt 1 ]
	then
		sclk_f=1
	elif [ $inp -gt $count ]
	then
		sclk_f=$count
	else
		sclk_f=$inp
	fi
else
	sclk_f=$sclk_def
fi

#echo "Formatted input is: $sclk_f."
setting=`echo $speeds | awk '{ print $'$sclk_f' }'`

if [ $chk_clock = "auto" ]
then
	sudo echo "manual" > /sys/class/drm/card0/device/power_dpm_force_performance_level
	#echo "sudo echo $eout > /sys/class/drm/card0/device/pp_dpm_sclk"
	sudo echo $eout > /sys/class/drm/card0/device/pp_dpm_sclk 
fi

#The actual value to echo -- the index for the setting
eout=`echo "$sclk_f - 1" | bc`

if [ $speed -ne $setting ] 
then
	#echo "sudo echo $eout > /sys/class/drm/card0/device/pp_dpm_sclk"
	sudo echo $eout > /sys/class/drm/card0/device/pp_dpm_sclk
fi

#echo "Current clock speed is: $speed. Speed setting is: $setting MHz. Input is: $sclk_f ($eout) Possible speeds count: $count."
