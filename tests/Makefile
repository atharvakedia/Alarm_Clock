# These targets are meant to be run in the build container!

test:
	pytest -k "part$(PART)" -s -W ignore::UserWarning

test_all:
	pytest -s -W ignore::UserWarning
