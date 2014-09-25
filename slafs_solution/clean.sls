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
    file.absent:
        - names:
            - /tmp/contest
            - /tmp/pip_build_root
    pip.removed:
        - name: virtualenv
    pkg.purged:
        - pkgs:
            - python-pip
            # - curl
            # - telnet
