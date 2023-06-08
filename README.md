# `sh-touch` project ver.: `0.9.4-beta`
[![Donate](https://img.shields.io/static/v1?label=Donate&message=paypal.me/biesior&color=brightgreen 'Donate the contributor via PayPal.me, amount is up to you')](https://www.paypal.me/biesior/4.99EUR)
[![State](https://img.shields.io/static/v1?label=sh-touch&message=0.9.4-beta&color=blue 'Latest known version')](https://github.com/sh-touch/sh-touch/)
[![Minimum bash version](https://img.shields.io/static/v1?label=bash&message=3.2+or+higher&color=blue 'Minimum Bash version to run this script')](https://www.gnu.org/software/bash/)

Note: This is ultra basic instruction in development, will be written better soon.
Steps below should work on Ubuntu and other Linuxes

It creates isolated environment for testing using ddev (kudos goes to Ghanshyam for concept )

# Installation

1. Use DDEV for isolating unknown code for testing! Use your own set of ports if you don't like these bellow. Just be sure, that the isolated environment won't disturb your other _every-day_ project(s). 
   ```
   mkdir ~/_tango_IsolatedShTouchTestEnv \
      && cd ~/_tango_IsolatedShTouchTestEnv \
      && ddev config \
         --project-name=IsolatedShTouchTestEnv \
         --create-docroot \
         --docroot=public_isolated \
         --http-port=21080 \
         --https-port=21443 \
         --mailhog-port=21085 \
         --mailhog-https-port=21086 \
         --omit-containers="db,dba" \
     && ddev exec "git clone https://github.com/sh-touch/sh-touch.git ~/sh-touch"
   ```
2. Go to DDEV's container shell
   ```
   ddev ssh
   ```

3. Clone repo into home directory and install the script.
   ```
   cd ~ \
      && git clone https://github.com/sh-touch/sh-touch.git \
      && ~/sh-touch/bin/install-dev.sh
   ```
4. To restart in-container cloning and installation just delete the folder and repeat step 4
   ```
   rm -fr ~/sh-touch \
      && rm /usr/local/bin/sh-touch \
      && echo -e "Repeat step 4"
   ```

# start using `sh-touch` command in your terminal 😍



See documentation of [sh-touch](resources/help/sh-touch.md) command for details.

