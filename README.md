# PKGBUILDS and other scripts made for random people & frogs

<p align="center">
  <img src="https://cdn.discordapp.com/attachments/472158720399245323/501778941913202708/tkgfrogu.png">
</p>
Thanks to Kassin for the meme-worthy banner

## How-to use that mess :

### While some of the scripts might work fine on any distro, the PKGBUILDs will only work on distros with access to pacman and makepkg.
**If you need to access pacman and makepkg outside of Arch-linux and distros based on it (like Antergos or Manjaro), you can "hijack" your current distro with Bedrock Linux at your own risk: https://bedrocklinux.org**  

 * Clone the whole thing (that enables you to use `git submodule update --remote` to get updates) :
```
git clone --recurse-submodules https://github.com/Tk-Glitch/PKGBUILDS.git
```

 * You can also choose to clone only the repos you need. All submodules can be found here: https://github.com/Frogging-Family

 * Build packages :

From the directory of the package you want to build (where the PKGBUILD is located), run
```
makepkg -si
```
That will grab the required dependencies, build, then install the newly created package(s).


 * For bash scripts, just run them from their respective directory - You might find additional details in the readme dedicated to the tool you want to build.

 * For your convenience, a script is available in the root of PKGBUILDS to pull updates and create external configuration files easily: `./TkgThingy`


## Why aren't the PKGBUILDs on AUR ?! :

While some are already available there without userpatches or lib32 support, the most interesting ones aren't (namely linux kernels, nvidia-all and wine-tkg-git) because of the way they are working. You're prompted for options or even config file editing to get the package customized the way you want it to be. For nvidia-all, there's no way around it so I'd consider that non-AUR compliant by default. For linux kernels and wine-tkg-git, I could indeed provide a fixed preset and remove all prompts. That would work. But then, are these still as interesting without customization? I strongly believe they aren't.


### Daily builds (pacman packages) for most packages are available at Chaotic-AUR (https://wiki.archlinux.org/index.php/Unofficial_user_repositories#chaotic-aur):
- Always up to date instructions on how to add Chaotic-AUR as repo can be found at [https://aur.chaotic.cx](https://aur.chaotic.cx) - Thanks Pedro !


**Wanna talk about it? Need help? Feel free to join the Frogging Family discord server : https://discord.gg/jRy3Nxk**

**If you like my work, consider visiting my patreon page : https://www.patreon.com/tkglitch**

## Thanks to Dr. Bright, Ryan, openglfreak, Thomas, liq, Amy, William, Sigge, Varris, nvaert1986, Eduard, Justin, Oscar, frankbaier, Jon, Sasamus, darkmaster879, redgloboli, flightlessmango, IroAlexis, gardotd426, Gabe E, Vitalwonhyo, Glorious Eggroll, Hans-Kristian, Anisan, Jonny Teronni, Zs. Cs. Sz., JudgeVanadium, Lutris, Oli, Fábio, Bill, Kristoffer, Typhoon, Ole Erik, Stephan, contributors, and all anonymous Patrons, supporters and curious minds! You're giving driving energy and purpose to my work. Much frog love to all of you guys <3


**You can also donate to me via https://www.paypal.me/TkGlitch**
