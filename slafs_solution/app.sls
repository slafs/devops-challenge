python-pip:
    pkg.installed


virtualenv:
    pip.installed:
        - require:
            - pkg: python-pip


/tmp/devops_challenge_virtualenv:
    virtualenv.managed:
        - system_site_packages: False
        - requirements: salt://MicroCounter/requirements.txt
        - require:
            - pip: virtualenv


redis-server:
    pkg.installed
    service.running



