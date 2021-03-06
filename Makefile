.PHONY: setup clean test test_unit flake8 autopep8 upload
BUMP := 'patch'

setup:
	@pip install -Ue .\[tests\]

clean:
	rm -rf .coverage
	find . -name "*.pyc" -exec rm '{}' ';'

unit test_unit test: clean flake8
	@nosetests -v --with-cover --cover-package=aiostomp --with-yanc -s tests/
	@$(MAKE) coverage

focus:
	@nosetests -vv --with-cover --cover-package=aiostomp \
		--with-yanc --logging-level=WARNING --with-focus -i -s tests/

coverage:
	@coverage report -m --fail-under=80

coverage_html:
	@coverage html
	@open htmlcov/index.html

flake8:
	flake8 aiostomp/
	flake8 bench/
	flake8 tests/

patch:
	@$(eval BUMP := 'patch')

minor:
	@$(eval BUMP := 'minor')

major:
	@$(eval BUMP := 'major')

bump:
	@bumpversion ${BUMP}

upload:
	python ./setup.py sdist upload -r pypi
