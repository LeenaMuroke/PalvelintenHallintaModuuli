# Raportti moduulin teolle

## Ympäristön listaus

Pääkone:
- Kannettava tietokone: Lenovo IdeaPad 5 Pro
- Käyttöjärjstelmä: Microsoft Windows 11 Home
- Prosessori: AMD Ryzen 7 5800U with Radeon Graphics
- RAM: 16 GB
- Tähän asennettu Vagrantin avulla virtuaalikoneita

Virtuaalikoneet:
- Oracle VirtualBox 6.1.40
- Käyttöjärjestelmä: Debian Bullseye 64-bit
- Käytössä useita samanlaisia virtuaalikoneita

## Moduulin aihe

Muiden moduuleista innostuneena, päätän lähteä yrittämään LAMP-moduulia, jonka avulla konfiguroidaan uusia koneita.
LAMP tulee sanoista L = Linux käyttöjärjstelmä, A = Apache webpalvelin, M = MariaDB tietokanta ja P = Python ohjelmointikieli.
Moduulia tullaan ajamaan Saltin avulla herra ja minionkoneiden välillä. 
Eli moduuli asentaa tarvittavat välineet aloittaa tekemään omia koodaustehtäviä. 
Valitsin tämän, sillä koen tästä olevan itselle hyötyä omiin projekteihini. 
Lisäksi tässä on sopivan verran tuttua mutta myös uutta haastetta.

## Alkutilanne

Minulla itselläni on pääkoneena vielä Windows 11. Asensin siihen Vagrantin, jolla määrittelin kaksi konetta: herra ja minioni.
Herrakoneesta tulee Salt-masteri, eli tällä koneella teen moduulin, jota sitten ajan ja testaan minionkoneella. 
Pystyn helposti tuhoamaan ja luomaan uuden minionkoneen Vagrantin avulla,
joten pääsen helposti testaamaan ns. puhtaalta pöydältä moduulin edistymistä. 
Itse koneiden asennusta en tässä raportissa avaa sen tarkemmin, sillä se on ollut osa jo aiempia viikkotehtäviä.
Eli keskityn tässä raportissa itse moduuliin, sen rakentamiseen ja testaamiseen.

Itse tämä raportti kirjoitetaan kokonaan herrakoneelta käsin, ja työnnetään GitHubiin. 
Eli itse rakennusprosessin aikanakin pääsen testaamaan versionhallintaa oikeanlaisessa ympäristössä.

## Salt-herran ja minioni koneiden yhdistäminen

Asensin herrakoneelle Salt-masterin `sudo apt-get install salt-master` ja minionkoneella salt-minionin `sudo apt-get install salt-minion`.
Tarkisin herrakoneen julkisen IP-osoitteen `hostname-I`.
Muokkasin minionkoneen Saltin asetustiedostoa `sudoedit /etc/salt/minion` 
ja lisäsin tiedoston alkuun "master: kyseinen IP-osoite". 
Käynnistin minionin Saltin uudestaan `sudo systemctl restart salt-minion.service`.  
Hyväksyin herrakoneella minionkoneelta tulleen avaimen ottaa yhteyttä `sudo salt-key -A`.
Testasin herrakoneelta käsin minionkonetta antamalla Saltkäskyn minioneille 
`sudo salt '*' cmd.run "hostname -I"`. Minioni vastasi, eli Salt yhteys toimii koneiden välillä.

    vagrant@herra:~$ hostname -I
    10.0.2.15 192.168.88.101
    vagrant@herra:~$ sudo salt-key -A
    The following keys are going to be accepted:
    Unaccepted Keys:
    minioni
    Proceed? [n/Y] y
    Key for minion minioni accepted.
    vagrant@herra:~$ sudo salt '*' cmd.run "hostname -I"
    minioni:
        10.0.2.15 192.168.88.102
        
  
