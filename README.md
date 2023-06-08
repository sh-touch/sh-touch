# `sh-touch` project ver.: `0.9.0-beta`
[![Donate](https://img.shields.io/static/v1?label=Donate&message=paypal.me/biesior&color=brightgreen 'Donate the contributor via PayPal.me, amount is up to you')](https://www.paypal.me/biesior/4.99EUR)
[![State](https://img.shields.io/static/v1?label=sh-touch&message=0.9.0-beta&color=blue 'Latest known version')](https://github.com/sh-touch/sh-touch/)
[![Minimum bash version](https://img.shields.io/static/v1?label=bash&message=3.2+or+higher&color=blue 'Minimum Bash version to run this script')](https://www.gnu.org/software/bash/)

Note: This is ultra basic instruction in development, will be written better soon.
Steps below should work on Ubuntu and other Linuxes

It creates isolated environment for testing using ddev (kudos goes to Ghanshyam for concept )

#Instalation
1. Create _tango_isolation dir and cd to it: 
   ```
   mkdir _tango_isolation
   cd _tango_isolation
   ```
2. Use ddev for isolating unknown code for test! Use your own set of ports if you don't like these bellow. Just be sure, that the isolated environment won't disturb your other projects. 
   ```
   ddev config --project-name=IsolatedShTouchTestEnv \
               --create-docroot \
               --docroot=public_isolated \
               --http-port=21080 \
               --https-port=21443 \
               --mailhog-port=21095 \
               --mailhog-https-port=21096 
   ```
3. Go to DDEV's container shell
   ```
   ddev ssh
   ```

4. Clone repo into home directory and install to script.
   ```
   cd ~
   ```
   
   ```
   git clone https://github.com/sh-touch/sh-touch.git
   ```
   
   ```   
   cd sh-touch
   ```
   ```
   git checkout dev
   ```
  
   ```
   ln -s bin/sh-touch.sh /user/local/bin/sh-touch
   ```

  ```
   cd ~ \
   && git clone https://github.com/sh-touch/sh-touch.git \
   && cd sh-touch \
   && git checkout dev \
   && ln -s bin/sh-touch.sh /user/local/bin/sh-touch
   ```



See documentation of [sh-touch](resources/help/sh-touch.md) command for details.

