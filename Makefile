.PHONY: install
install:
	python manage_dotfiles.py -a
	python manage_dotfiles.py -c
	python manage_dotfiles.py -P
.PHONY: archive
archive:
	python manage_dotfiles.py -a
.PHONY: import
import:
	python manage_dotfiles.py -p
.PHONY: delete
delete:
	python manage_dotfiles.py -d
.PHONY: repo-push
repo-push:
	hg bookmark master
	-hg push git+ssh://git@github.com:mpenning/dotfiles.git
.PHONY: help
help:
	@echo ""
	@echo "  make install      : Install these dotfiles as symlinks"
	@echo "  make archive      : Archive your existing dotfiles"
	@echo "  make delete       : Delete all existing dotfile symlinks (Use with caution!)"
	@echo "  make import       : Import dotfiles into permissions.json"
