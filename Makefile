.PHONY: clean clean-test clean-pyc clean-build docs help
.DEFAULT_GOAL := help

define BROWSER_PYSCRIPT
import os, webbrowser, sys

from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

lint: ## check style with flake8
	flake8 spotify_playlist_additions_core

test: ## run tests quickly with the default Python
	pytest

test-all: ## run tests on every Python version with tox
	tox

coverage: ## check code coverage quickly with the default Python
	coverage run --source spotify_playlist_additions_core -m pytest
	coverage report -m
	coverage html
	$(BROWSER) htmlcov/index.html

check-coverage: ## Runs a test to ensure the test % is above 80%
	coverage run --source spotify_playlist_additions_core -m pytest
	coverage report -m --fail-under=80

docs: ## generate docs using mkdocs
	mkdocs build

servedocs: ## compile the docs watching for changes
	mkdocs serve

release: dist ## package and upload a release
	twine upload dist/*

dist: clean ## builds source and wheel package
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist

install: clean ## install the package to the active Python's site-packages
	python setup.py install

venv: ## creates a venv with all requirements and the package installed
	$(shell which python3) -m venv .venv
	. .venv/bin/activate; \
	pip install -r requirements_dev.txt; \
	pip install -e .
	ln -sfn .venv/bin/activate activate
	@echo "Use 'source ./activate' to enter virtual environment"

check-types:  ## Does static type checking on the code
	mypy -p spotify_playlist_additions_core --ignore-missing-imports

show-types: check-types ## Shows the type checking report after running the type checker
	$(BROWSER) .mypyreport/index.html