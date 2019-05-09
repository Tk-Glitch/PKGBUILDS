# PKGBUILDS and other scripts made for random people & frogs

<p align="center">
  <img src="https://cdn.discordapp.com/attachments/472158720399245323/501778941913202708/tkgfrogu.png">
</p>

## How-to use that mess :

### While some of the scripts might work fine on any distro, the PKGBUILDs will only work on distros with access to pacman and makepkg.
**If you need to access pacman and makepkg outside of Arch-linux and distros based on it (like Antergos or Manjaro), you can "hijack" your current distro with Bedrock Linux at your own risk: https://bedrocklinux.org**  

**Look through the pages in "Current release" for usage, tips & tricks, what isn't supported, and workarounds if necessary.**

 * Clone the whole thing (that enables you to use `git pull` to get updates) :
```
git clone https://github.com/Tk-Glitch/PKGBUILDS.git
```

 * Build packages :

From the directory of the package you want to build (where the PKGBUILD is located), run
```
makepkg -si
```
That will grab the required dependencies, build, then install the newly created package(s).


 * For bash scripts, just run them from their respective directory.


 * You can also clone a single folder from the repo (you need to have the `subversion` package installed) but it might break inter-dependencies :
```
svn export https://github.com/Tk-Glitch/PKGBUILDS/trunk/folder_name
```
*For example, in case you want to clone the nvidia-dev-all folder, the command would be :* `svn export https://github.com/Tk-Glitch/PKGBUILDS/trunk/nvidia-dev-all`


## Why aren't the PKGBUILDs on AUR ?! :

While some are already available there without userpatches or lib32 support, the most interesting ones aren't (namely linux kernels, nvidia-all and wine-tkg-git) because of the way they are working. You're prompted for options or even config file editing to get the package customized the way you want it to be. For nvidia-all, there's no way around it so I'd consider that non-AUR compliant by default. For linux kernels and wine-tkg-git, I could indeed provide a fixed preset and remove all prompts. That would work. But then, are these still as interesting without customization? I strongly believe they aren't.

**Wanna talk about it? Need help? Feel free to join the Frog Family discord server : https://discord.gg/jRy3Nxk**

**If you like my work, consider visiting my patreon page : https://www.patreon.com/tkglitch**

## Thanks to Furkan Mustafa and all my anonymous Patrons! Much frog love to you guys <3


**You can also donate to me via https://www.paypal.me/TkGlitch**
