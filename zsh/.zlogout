# Clean up tmpenvs on shell logout.
# https://virtualenvwrapper.readthedocs.io/en/latest/tips.html#clean-up-environments-on-exit
expr "$VIRTUAL_ENV" : '.*tmp-[[:alnum:]]\+$' > /dev/null && deactivate
