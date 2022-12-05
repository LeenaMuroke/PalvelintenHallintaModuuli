# Raportti moduulin teolle

# Ympäristön listaus

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

# Alkutilanne

Muiden moduuleista innostuneena, päätän lähteä yrittämään LAMP-moduulia, jonka avulla konfiguroidaan uusia koneita.
LAMP tulee sanoista L = Linux käyttöjärjstelmä, A = Apache webpalvelin, M = MariaDB tietokanta ja P = Python ohjelmointikieli.
Eli moduuli asentaa tarvittavat välineet aloittaa tekemään omia koodaustehtäviä. 
Valitsin tämän, sillä koen tästä olevan itselle hyötyä omiin projekteihini. Lisäksi tässä on sopivan verran tuttua mutta myös uutta haastetta.

# 

Minulla itselläni on pääkoneena vielä Windows 11. Asensin siihen Vagrantin, jolla määrittelin kaksi konetta: herra ja minioni.
Herrakoneesta tulee Salt-masteri, eli tällä koneella teen moduulin, jota sitten ajan ja testaan minionkoneella. 
Pystyn helposti tuhoamaan ja luomaan uuden minionkoneen Vagrantin avulla,
joten pääsen helposti testaamaan ns. puhtaalta pöydältä moduulin edistymistä. 
Itse koneiden asennusta en tässä raportissa avaa sen tarkemmin, sillä se on ollut osa jo aiempia viikkotehtäviä.
Eli keskityn tässä raportissa itse moduuliin, sen rakentamiseen ja testaamiseen.

Itse tämä raportti kirjoitetaan kokonaan herrakoneelta käsin, ja työnnetään GitHubiin. 
Eli itse rakennusprosessin aikanakin pääsen testaamaan versionhallintaa oikeanlaisessa ympäristössä.

