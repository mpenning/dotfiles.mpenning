# dotfiles

This project helps to safely manage your dotfiles on github with 
minimal effort.  Perhaps you know that revision control tools like
``git`` and ``hg`` only store the executable bit in revision 
control; this project:

- Keeps track of changes to your dotfile permissions on github
- Restores permissions during new installations
- Archives your existing dotfile conflicts before clobbering them

The guts of the project are in two files:

- ``dotfiles/Makefile``:  The main user interface
- ``dotfiles/manage_dotfiles.py``: Most of the smarts mentioned above are here

## Initial installation (from github)

This assumes all your dotfiles in your unix home directory are intact.

### Using `git`

To install the project, `cd` to your home directory, and `git clone`...

    cd
    git clone git://github.com/mpenning/dotfiles.git

### Using `hg-git`

To install the project, `cd` to your home directory, and `hg clone`...

    cd
    hg clone git://github.com/mpenning/dotfiles.git

### Keeping  *only* my dotfiles in revision control...

Once you have done this, ~/dotfiles contains all *my* personal dotfiles.
If you only want to use my dotfiles, then type...

    cd ~/dotfiles
    make install

This will archive your conflicting dotfiles into ~/dotfiles.orig.[timestamp]
and move them into that directory.  Then it will symlink the dotfiles in 
~/dotfiles to your home directory.

### Adding some of your own dotfiles into revision control...

Just ``cd`` to your home directory and move the dotfiles / dot directories
of your choice into ~/dotfiles.  Now type ``make import``, add/commit to your
repo, and push to your github account.
