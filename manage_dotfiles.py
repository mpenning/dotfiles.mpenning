from logging.handlers import TimedRotatingFileHandler
from logging.handlers import MemoryHandler
from optparse import OptionParser
from datetime import datetime
from warnings import warn
from shutil import move
from glob import glob
import fnmatch
import logging
import json
import stat
import sys
import re
import os

NO_PERMISSION_METADATA = ['snmp']
EXCLUDE_AS_DOTFILES = set(['.hg', '.git', 'README.md', 'Makefile', 'manage_dotfiles.py', 'permissions.json'])

## no .pyc file...
sys.dont_write_bytecode = True

def parse_options():
    parser = OptionParser()
    parser.add_option("-a", "--archive", dest="archive", action='store_true',
                      default=False,
                      help="Create an archive of your current valid dotfiles")
    parser.add_option("-c", "--create", dest="create", action='store_true',
                      default=False,
                      help="Create symlink'd dotfiles in your home directory")
    parser.add_option("-f", "--force", dest="force", action='store_true',
                      default=False,
                      help="Force action")
    parser.add_option("-p", "--permissions", dest="wpermissions", action='store_true',
                      default=False,
                      help="Write a permissions file (~/dotfiles/permissions.json)")
    parser.add_option("-P", dest="spermissions", action='store_true',
                      default=False,
                      help="Set dotfile permissions (from ~/dotfiles/permissions.json)")
    return parser.parse_args()[0]

def init_logs(log_level=2, log_stdout=False, 
    log_path=os.path.expanduser('~/dotfiles.log')):
    if log_level:
        log = logging.getLogger(__name__)
        fmtstr = '%(asctime)s.%(msecs).03d %(levelname)s %(message)s'
        format = logging.Formatter(fmt=fmtstr, datefmt='%Y-%m-%d %H:%M:%S')
        log.setLevel(logging.DEBUG)

        if log_path:
            ## Rotate the logfile every day...
            rotating_file = TimedRotatingFileHandler(log_path,
                when="D", interval=1, backupCount=5)
            rotating_file.setFormatter(format)
            memory_log = logging.handlers.MemoryHandler(1024*10, 
                logging.DEBUG, rotating_file)
            log.addHandler(memory_log)
        if log_stdout:
            console = logging.StreamHandler()
            console.setFormatter(format)
            log.addHandler(console)

        if not bool(log_path) and (not log_stdout):
            log_level = 0

    return log

def excludes(full_path=False):
    this_dir = this_directory()
    if not full_path:
        prefix = ''
    else:
        prefix = this_dir
    if not full_path:
        return EXCLUDE_AS_DOTFILES
    else:
        return set([os.path.join(prefix, file) for file in EXCLUDE_AS_DOTFILES])

def dotfile(filename):
    """When a dot filename is input, return a dotfile path referenced to the """
    """user's home directory"""
    return os.path.expanduser('~/')+filename

def this_directory():
    """Return the directory this script is in (should be ~/dotfiles)"""
    this_file = os.path.realpath(__file__)
    return os.path.sep.join(this_file.split(os.path.sep)[:-1])

def valid_dotfile_targets(full_path=False):
    EXCLUDE = excludes()
    this_dir = this_directory()
    if not full_path:
        prefix = ''
    else:
        prefix = this_dir
    return [os.path.join(prefix, file) for file in os.listdir(this_dir)
         if not file in excludes(full_path=False)]

def valid_dotfile_permissions():
    """Return a dictionary of all valid dotfiles, mapped to  """
    """their octal permissions."""
    permissions = dict()
    ST_MODE = stat.ST_MODE
    for elem in recurse_valid_dotfiles(this_directory()):
        for file in glob(elem+'*'):
            permissions[file] = oct(stat.S_IMODE(os.stat(file).st_mode))
    return permissions

def recurse_valid_dotfiles(directory):
    """Return a list of valid dotfiles, recursing through any """
    """required dot directories.  Administrative files are removed"""
    """(i.e. remove dotfiles/README, dotfiles/Makefile, etc...)"""
    files = list()
    exclude_paths = excludes(full_path=True)
    for root, dirnames, filenames in os.walk(directory):
      for filename in fnmatch.filter(filenames, '*'):
          candidate = os.path.join(root, filename)
          if filter(lambda x: x in candidate, NO_PERMISSION_METADATA):
              # Remove any paths in NO_PERMISSION_METADATA
              continue
          elif filter(lambda x: x in candidate, exclude_paths):
              # Remove any paths in EXCLUDE_AS_DOTFILES
              continue
          else:
              files.append(candidate)
    return files

def build_dotfile_symlinks():
    pass

if __name__=="__main__":
    opts = parse_options()
    log = init_logs()
    home_dir = os.path.expanduser('~/')
    if opts.create:
        links = zip(valid_dotfile_targets(full_path=True), 
            valid_dotfile_targets())
        log.info("Creating symbolic links for {} in {}".format([link[1] for link in links], 
            os.path.expanduser('~/')))
        for link in links:
            log.info("  Evaluating symlink for ~/dotfiles/{}".format(link[1]))
            dotfile_homedir = os.path.join(home_dir, link[1])
            dotfile_github = link[0]    # File in the ~/dotfiles directory
            skip_link = False

            # Remove conflicts, selectively 
            if not os.path.exists(dotfile_homedir):
                pass
            elif os.readlink(dotfile_homedir)==dotfile_github:
                # Skip the symbolic link
                skip_link = True
                log.info("    [SKIP] Symlink for {}, because it already exists".format(dotfile_homedir))
            elif opts.force:
                log.info("    [REMOVE] Symlink: {} -> {}".format(dotfile_homedir, os.readlink(dotfile_homedir)))
                os.remove(dotfile_homedir)

            # Symbolic link to ~/dotfiles...
            if skip_link:
                continue
            elif (not os.path.islink(dotfile_homedir)):
                if not os.path.exists(dotfile_homedir):
                    log.info("    [CREATE] Symlink: {} -> {}".format(dotfile_homedir, dotfile_github))
                    os.symlink(dotfile_github, dotfile_homedir)
                else:
                    log.info("    [WARNING] Refusing to overwrite {}; please archive first.".format(dotfile_homedir))
                    warn("Refusing to overwrite file {}; please archive first.".format(dotfile_homedir))
            else:
                log.info("    [WARNING] Refusing to overwrite link {}; please archive first.".format(dotfile_homedir))
                warn("Refusing to overwrite symlink for {}".format(link[0]))
    elif opts.archive:

        tt = datetime.now().strftime("%Y%m%d-%H%M%S")
        dotfile_archive = os.path.join(home_dir, 'dotfiles.orig.{}'.format(tt))
        archive_dir = False    # Has the archive directory been created?

        dotfiles_github = valid_dotfile_targets(full_path=True)
        log.info("Archiving dotfiles in ~/")
        if not os.path.exists(dotfile_archive):
            for file in valid_dotfile_targets(full_path=False):
                dotfile_homedir = os.path.join(home_dir, file)
                if os.path.islink(dotfile_homedir):
                    if filter(lambda x: dotfile_homedir==x, dotfiles_github):
                        # Always remove links if they link to the ~/dotfile dir
                        os.remove(dotfile_homedir)
                elif not os.path.islink(dotfile_homedir) or opts.force:
                    if not archive_dir:
                        log.info("    [CREATE] Archive directory: {}".format(dotfile_archive))
                        os.mkdir(dotfile_archive)  # Build dotfile archive dir
                        archive_dir = True
                    try:
                        move(dotfile_homedir, dotfile_archive)
                        log.info("    [MOVE] {} -> Archive".format(dotfile_homedir))
                    except IOError:
                        # Can't archive dotfile_homedir... it's new
                        pass
        else:
            log.info("    [ERROR] Refusing to overwrite archive {}, it already exists".format(dotfile_archive))
            warn("Refusing to overwrite {}".format(dotfile_archive))
    elif opts.wpermissions:
        log.info("Imported permissions for ~/dotfiles: {}".format(valid_dotfile_targets()))
        permissions = valid_dotfile_permissions()
        with open('permissions.json', 'w') as fh:
            json.dump(permissions, fh)

    elif opts.spermissions:
        log.info("Setting permissions on ~/dotfiles")
        with open('permissions.json', 'rU') as fh:
            permissions = json.load(fh)
        for dotfile_github, perm in permissions.items():
            # Permissions are stored as octal strings
            os.chmod(dotfile_github, int(perm, 8))
            log.info("    [CHMOD] {} to {}".format(dotfile_github, perm))
