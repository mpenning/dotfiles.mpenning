.PHONY: install
install:
	python manage_dotfiles.py -a
	python manage_dotfiles.py -c
	python manage_dotfiles.py -P
.PHONY: clean
clean:
	python manage_dotfiles.py -a
.PHONY: import
import:
	python manage_dotfiles.py -p
.PHONY: help
help:
	@echo ""
	@echo "  make install      : Install these dotfiles as symlinks"
	@echo "  make clean        : Archive your existing dotfiles"
	@echo "  make import       : Import new dotfiles into permissions.json"
