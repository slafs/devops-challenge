{% if grains['os_family'] in ('Debian', 'Ubuntu') %}
{% set redis_pkg_name='redis-server' %}
{% else %}
{% set redis_pkg_name='redis' %}
{% endif %}

clean_redis:
    service:
        - name: {{ redis_pkg_name }}
        - dead
        - disable: True
    pkg.purged:
        - pkgs:
            - redis-server
        - require:
            - service: clean_redis


clean:
    cmd.run:
        - name: kill $(cat /tmp/contest/gunicorn.pid)
        - onlyif: test -f /tmp/contest/gunicorn.pid
    file.absent:
        - names:
            - /tmp/contest
            - /tmp/pip_build_root
        - require:
            - cmd: clean
    pip.removed:
        - name: virtualenv
    pkg.purged:
        - pkgs:
            - python-pip
            # - curl
            # - telnet
