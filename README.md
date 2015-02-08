# dotfiles

This project helps to safely manage your dotfiles on github with 
minimal effort.  Perhaps you know that revision control tools like
``git`` and ``hg`` only store the executable bit from your 
file system in revision control; this means if you have a file as
750, these permissions could be different when you pull that
repo again.  This project:

- Keeps track of changes to your dotfile contents on github
- Keeps track of changes to your dotfile *permissions* on github
- *Restores permissions* during new installations
- Archives your existing dotfile conflicts before clobbering them
- Logs activity in case you need to figure out what happened (see ``~/dotfiles.log``)

The guts of the project are in two files:

- ``dotfiles/Makefile``:  The main user interface
- ``dotfiles/manage_dotfiles.py``: Most of the smarts mentioned above are here

This script will *always* ignore the following dotfiles / dot directories:

- ``.hg``: Mercurial uses this directory for repository metadata
- ``.git``: Git uses this directory for repository metadata

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

``make install`` will:
- create an archive directory called ~/dotfiles.orig.[timestamp], if requried
- move any conflicting dotfiles into that directory
- symlink the dotfiles in ~/dotfiles to your home directory.  
- Walk your ~/dotfiles directory and change permissions to those you saved the last time you performed ``make import``

### Adding some of your own dotfiles into revision control...

If you want to add some of your own dotfiles, (or remove some of mine)...

- ``cd`` to your home directory and move the dotfiles / dot directories
of your choice into ~/dotfiles.
- ``cd ~/dotfiles``
- ``make delete``. This option will delete all existing symlinks into ``~/dotfiles``
- Add or delete my dotfiles as you wish.  Be sure you do not touch the ``~/dotfiles/.git`` or ``~dotfiles/.hg`` directories, which contain all the repo metadata
- ``make import``
- ``make install``
- add/commit to your local repo, and push to your github account.

``make import`` is a ``Makefile`` target which saves your permissions on 
github.  It uses ``manage_dotfiles.py`` to save all your dotfile permissions in 
``~/dotfiles/permissions.json``.  When you pull the repo from github and do
``make install``, the permissions are read from ``permissions.json`` and 
appled to your repo.

## License and Copyright

This software is licensed with a BSD 3-clause license; Copyright 2015 (c) David Michael Pennington
