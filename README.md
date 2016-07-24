# blink
CHIP program to blink status LED and shut down when reset if briefly pressed.

## License

I want there to be NO barriers to using this code, so I am releasing it to the public domain.  But "public domain" does not have an internationally agreed upon definition, so I use CC0:

Original Copyright 2016 Steven Ford http://geeky-boy.com and licensed
"public domain" style under
[CC0](http://creativecommons.org/publicdomain/zero/1.0/): 
![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png "CC0")

(This version has been modified by Gonzalo Cao and released under same license)


To the extent possible under law, the contributors to this project have
waived all copyright and related or neighboring rights to this work.
In other words, you can use this code for any purpose without any
restrictions.  This work is published from: United States.  The project home
is https://github.com/fordsfords/blink/tree/gh-pages

To contact me, Steve Ford, project owner, you can find my email address
at http://geeky-boy.com.  Can't see it?  Keep looking.

## Introduction

The [CHIP](http://getchip.com/) single-board computer runs Linux.  As a result, it should be shut down gracefully, not abruptly by removing power.  But CHIP is often used as an embedded system without any user interface.  In those cases, it can be difficult to know if it has successfully booted, and is difficult to trigger a graceful shutdown.  This program solves both problems.

* When started at boot time, the blinking status LED indicates a successful boot.  Its continuing blinking indicates that CHIP hasn't crashed.

* When the small reset button is pressed BRIEFLY, the blink program will initiate a graceful shutdown.  WARNING: do not press and hold the button.  That will perform a non-graceful power off.  This should only be done if CHIP cannot be shut down gracefully.

You can find blink on github.  See:

* User documentation (this README): https://github.com/gonzalo/blink/tree/gh-pages

Note: the "gh-pages" branch is considered to be the current stable release.  The "master" branch is the development cutting edge.

## Quick Start

These instructions assume you are in a shell prompt on CHIP.

1. Get the shell script file onto CHIP:

        sudo wget -O /usr/local/bin/blink.sh https://raw.githubusercontent.com/gonzalo/blink/master/blink.sh
        sudo chmod +x /usr/local/bin/blink.sh
        sudo wget -O /etc/systemd/system/blink.service https://raw.githubusercontent.com/gonzalo/blink/master/blink.service
        sudo systemctl enable /etc/systemd/system/blink.service
        sudo service blink start

After a few seconds watching the blinking LED, briefly press the reset button and watch CHIP shut down.  Restart CHIP, and when it has completed its reboot, watch the status LED start to blink again.


## Killing Blink

Since blink is a service, you can manually stop it with:

        sudo service blink stop


## Random Notes

1. There is an older C version of blink which uses a GPIO line instead of the reset button.  Given that the reset button is much better, I don't anticipate the C program will be of interest except perhaps as a simple example of a C program accessing the GPIO lines.

2. As long as the status LED continues to blink, you know that your CHIP is still running.  But if you are running some useful application, the blinking LED does not necessarily give you a good indication of the overall health of your system.  Basically, blink shows that the OS is still running, but your application may have crashed.

3. There are often ways of automatically monitoring the health of applications.  At a crude level, you can periodically run the "ps" command and at least make sure the process itself is still running.  Even better would be to be able to "poke" the application in some way to produce an expected result (like maybe sending it a signal and writing the application to write a message to a log file).  You could build this capability into blink, and if it detects a failure, change the blink rate of the LED (like to 3 pulses per second).  This still won't tell you *what* is wrong, but at least it narrows things down a bit.

## Release Notes
* 24-Jul-2016

    Changed blinking times (longer on, shorter off)

* 27-Jun-2016

    Changed service type from "forked", which was both misspelled AND the wrong
    choice, to "simple".  Also added spaces after the "-O" of wget to be more
    familliar.

* 26-Jun-2016

    Corrected typo.  Added version ID to blink script.  (Version ID is the
    release date.)

* 30-May-2016

    Checked for short button press properly (masking the correct bit).

* 16-May-2016

    Got rid of sleep 10.  Added "blink.service" to start as system service instead of cron job.  Also re-added the /tmp/blink.pid file.

* 17-Apr-2016

    Created shell script which accesses reset button instead of GPIO line.

* 21-Feb 2016

    Merged in Efreak's ontime/offtime

* 17-Feb-2016

    Added binary executable to package.  Updated quickstart to use it.  Made a few more improvements to documentation.  Also changed the 1 second sleep to 1 million microseconds to make it easier to use a faster blink rate.  Also added /tmp/blink.pid file.

* 24-Jan-2016

    Initial pre-release.
