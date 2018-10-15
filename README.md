# PKGBUILDS and other scripts made for random people online

# How-to use that mess :

Clone a single folder from this repo (you need to have the `subversion` package installed) :
```
svn export https://github.com/Tk-Glitch/PKGBUILDS/trunk/folder_name
```


Clone the whole thing (that enables you to use `git pull` to get updates) :
```
git clone https://github.com/Tk-Glitch/PKGBUILDS.git
```


Build packages :

From the directory of the package you want to build (where the PKGBUILD is located), run
```
makepkg -si
```
That will grab the required dependencies, build, then install the newly created package(s).


For bash scripts, just run them from their respective directory.
