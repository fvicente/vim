vim
===

Configuration for vim

```sh
# clone this repository
git clone https://github.com/fvicente/vim.git .vim
cd .vim
# get submodules
git pull && git submodule init && git submodule update && git submodule status
# create symbolic link
ln ~/.vim/.vimrc ~/.vimrc
# install better fonts script
sudo pip install git+git://github.com/Lokaltog/powerline
# install python lint
sudo easy_install flake8
# install jshint
npm install jshint
```

VimR
- http://vimr.org

Fonts on Mac (use Font Book to install)
- https://github.com/Lokaltog/powerline-fonts/tree/master/SourceCodePro
