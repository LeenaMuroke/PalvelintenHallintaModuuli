/var/www/html/index.html:
  file.managed:
    - contents: "Hello world"

/etc/apache2/mods-enabled/userdir.conf:
  file.symlink:
    - target: ../mods-available/userdir.conf

/etc/apache2/mods-enabled/userdir.load:
  file.symlink:
    - target: ../mods-available/userdir.load

/home/vagrant/public_html:
  file.recurse:
    - source: salt://apache/public_html
    - file_mode: 0755

apache2.service:
  service.running:
    - name: apache2
    - watch:
      - file: /etc/apache2/mods-enabled/userdir.conf
      - file: /etc/apache2/mods-enabled/userdir.load
