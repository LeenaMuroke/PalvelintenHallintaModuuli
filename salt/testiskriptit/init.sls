/usr/bin/testiskriptit.sh:
  file.managed:
    - source: salt://testiskriptit/testiskriptit.sh
    - mode: 0755
