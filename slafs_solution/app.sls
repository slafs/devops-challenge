{% if grains['os_family'] in ('Debian', 'Ubuntu') %}
{% set redis_pkg_name='redis-server' %}
{% else %}
{% set redis_pkg_name='redis' %}
{% endif %}

tempdir:
    file.directory:
        - name: /tmp/contest

packages:
    pkg.installed:
        - pkgs:
            - telnet
            - curl
            - python-pip

python-pip:
    pkg.installed:
        - refresh: false
        - require:
            - pkg: packages


virtualenv:
    pip.installed:
        - cwd: /tmp/contest
        - require:
            - pkg: python-pip


venv:
    virtualenv.managed:
        - name: /tmp/contest/virtualenv
        - cwd: /tmp/contest
        - system_site_packages: False
        - requirements: salt://MicroCounter/requirements.txt
        - require:
            - pip: virtualenv

gunicorn:
    file.managed:
        - name: /tmp/contest/gunicorn.conf.py
        - source: salt://MicroCounter/gunicorn.conf.py

redisserver:
    pkg:
        - installed
        - name: {{ redis_pkg_name }}
        - refresh: false
    service:
        - name: {{ redis_pkg_name }}
        - running

python-app:
    file.managed:
        - name: /tmp/contest/app.py
        - source: salt://MicroCounter/app.py

    cmd.run:
        - cwd: /tmp/contest
        - name: "/tmp/contest/virtualenv/bin/gunicorn -c /tmp/contest/gunicorn.conf.py -D app:app"
        - require:
            - service: redisserver
            - virtualenv: venv
            - file: gunicorn
            - file: python-app
