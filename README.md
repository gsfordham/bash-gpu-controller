# bash-gpu-controller
A Bash script to control AMD GPUs on GNU+Linux

*NOTE: Although the script file is called "gpu-slowmode.sh", it doesn't have to be used to slow down your GPU -- I just use it for underclocking to save power and keep it running cool.*

**NOTE: Feel free to rename the script -- I didn't, because I already set up several aliases and a ``cron`` job for it.**

*NOTE: This script can ONLY be run as the Superuser or a ``sudo`` user, since it modifies protected system control files*

This script should work for any single-card AMD GPU builds (has not been tested with multi-card/Crossfire).

This script functions by reading in both optional command-line input and the default file locations for AMD GPU controls on GNU+Linux, and then it checks for the number of possible GPU speeds and compares them with either the input or the default value (you can set the default value towards the top of the script under ``sclk_def=3`` -- change it to your preferred value; must be a valid index in the array).

USAGE: **``gpu-slowmode.sh [some index]``**, where ``[some index]`` is the GPU clock state's *index* you wish to use (GPU clock state list can be acquired by running: 
  **``sudo cat /sys/class/drm/card0/device/pp_dpm_sclk``** *AS THE SUPERUSER*,
 and the count of valid clock state indexes can be gotten with:
  **``sudo cat /sys/class/drm/card0/device/pp_dpm_sclk | wc -l``** *ALSO AS THE SUPERUSER*)

**TO DO**
1) Clean out commented debugging code
2) Remove redundant paths by using a variable
3) Possibly fix up the calls to ``sed`` to be more efficient
