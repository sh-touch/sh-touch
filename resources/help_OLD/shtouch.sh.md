# Help for `shtouch.sh` ver. `1.0.0-rc1`  

[![Donate](https://img.shields.io/static/v1?label=Donate&message=paypal.me/biesior&color=brightgreen 'Donate the contributor via PayPal.me, amount is up to you')](https://www.paypal.me/biesior/4.99EUR)
[![State](https://img.shields.io/static/v1?label=stable&message=1.0.0-rc1&color=blue 'Latest known version')](https://github.com/biesior/bash-scripts/)
[![Minimum bash version](https://img.shields.io/static/v1?label=bash&message=3.2+or+higher&color=blue 'Minimum Bash version to run this script')](https://www.gnu.org/software/bash/)

### What it does?  

As name suggest `touch` version of command for bash scripts.
It just creates scratch shell script with `.sh` or `.zsh`, proper shebang and sample code inside.

You can reuse sample code or remove it and write your own.

Just leave generated shebang.
See: https://en.wikipedia.org/wiki/Shebang_(Unix)

### Where  

`filepath` is absolute or relative path for new created script, if filename only given it will create script in current directory

`extension` should be `.sh` or `.zsh`, if not specified `.sh` will be added automatically.

`output` If specified, after creation the file it will be opened in this editor, possibilities:

##### Display  

  - `cat` displays generated code with `cat` command in terminal and returns to shell
  - `none` or blank writes output file without displaying/editing and returns to shell

##### Command line editors (if installed)  

  - `vim`
  - `nano`
  - `jed`

##### GUI editors on Mac (if installed)  

  - `edit` for default OSX editor
  - `sublime` for OSX Sublime Text.app
  - `textedit` for OSX TextEdit.app

### Samples  

##### (optionally)  

```bash
cd /path/with/your/executables
```

##### To create script with `#!/usr/bin/env bash` 5  

```bash
shtouch.sh foo.sh
```

##### To create script with `#!/usr/bin/env zsh` 5  
```bash
shtouch.sh foo.zsh
```

##### If extension is not given, the default bash is created:  

`shtouch.sh baz`
(creates `baz.sh` script with `#!/usr/bin/env bash` shebang)

##### Of course you can always use absolute or relative path for new file like:  

```bash
shtouch.sh /full/path/to/zen.sh
shtouch.sh ~/in-home-directory.sh
shtouch.sh in-current-directory.sh
```

##### If for some reason you want/need to use file without extension, just rename it after creation like  

```bash
mv new-script.sh new-script
```

### Exported variables  

To modify final output you can export some variables in your shell before executing `shtouch.sh`
or add selected exports to your profile file.

#### To check current exported variables, just `echo` one of them in your terminal, like   
```bash
echo $SHTOUCH_DEFAULT
```

##### To disable sample body:  
(allowed `true`, `false`)
```bash
export SHTOUCH_BODY=false
```

##### To disable generator comment:  
(allowed `true`, `false`)
```bash
export SHTOUCH_COMMENT=false
```

##### To disable colored output:  
(allowed `true`, `false`)
```bash
export SHTOUCH_COLORS=false
```

##### To set default extension to be used when auto mode  
* required extension must be no-spaces word, starting with dot like `.sh`, `.zsh`, `.my-own-extension`  
* suggested `.sh` or `.zsh`  
* default `.sh`  
```bash
export SHTOUCH_DEFAULT=.sh
```

##### That's all!  
Now you can run:
```bash
shtouch.sh have-fun-:-p
```

© 2020 Marcus biesior Biesioroff