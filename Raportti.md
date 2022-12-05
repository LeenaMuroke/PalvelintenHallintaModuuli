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

Eli samalla tavalla tulen tekemään myös minionkoneita ja niiden yhdistämisiä herrakoneeseen.
Tulen testaamaan moduuliani useamman kerran tyhjällä minionkoneella. 
Herrakonetta en tule tekemään uudestaan.

## Ohjelmian asennukset minionille skriptin avulla

Haluan aloittaa moduulin asentamalla tarvittavat paketit skriptin avulla,
jotta pääsen sitäkin harjoittelemaan. Loin aluksi kansion /srv/salt/, jonne rupean laittamaan Salt tilan määrityksiä.
Kansioon skripteille tilan alkuskriptit `sudo mkdir alkuskriptit` ja loin alkuskriptit.sh tiedoston `micro alkuskriptit.sh`, 
johon kirjasin skriptit tarvittavien pakettin asennukselle ja echolla kerrotaan terminaalissa mitä asennetaan.

<img width="310" alt="alkuskriptit" src="https://user-images.githubusercontent.com/111494018/205600054-929ae28a-f8ca-4312-a476-e6b3f1d979f2.png">

Tilan sisälle loin init.sls tiedoston `sudo micro init.sls`, johon alan määritellä tilan asetuksia.
Kirjoitin sisälle alla kuvassa olevat tiedot. Eli luodaan kansio koneen bin-hakemistoon, jotta skriptejä 
voi ajaa mistä tahansa koneella ollessa. Source tarkoittaa, että skriptitiedosto kopioidaan herrakoneen salt hakemiston 
alkuskriptit tilasta ja tiedosto alkuskriptit.sh on se joka kopioidaan minionille.
Mode viittaa oikeuksiin, millä skriptejä pystyy ajamaan.

<img width="266" alt="alkuskriptitsalt" src="https://user-images.githubusercontent.com/111494018/205600151-6fedf1c5-db0c-4b31-8b55-302e151f8c63.png">

Ajoin tilan herrakoneelta minionille `sudo salt '*' state.apply alkuskriptit`.
Tilan ajo mukamas onnistui. Kävin minion koneella katsomassa /usr/bin/ hakemistosta ja catilla luin alkuskriptitiedoston.
Sehän oli sinne tullut! Koitin ajaa skriptiedoston `bash alkuskriptit`, mutta ei onnistunut.
Tiedostonhan pitää olla .sh päätteinen, jotta terminaali osaa lukea sen shellskriptinä.
Kävin herrakoneella vaihtamssa Salt tilasta tiedoston .sh päätteiseksi ja ajoin tilan uudestaan. 
Tämä loi uuden tiedoston alkuskriptit.sh. Tämänkään jälkeen tila ei toiminut, syynä echolle olin laittanut ().
Tiedä mistä moinen aivopieru. Kävin taas muokkaamassa herrakoneelta alkuskriptit.sh tiedostoa ja ajoin koko tilan uudelleen.

    vagrant@herra:/srv/salt/alkuskriptit$ sudo salt '*' state.apply alkuskriptit
    minioni:
    ----------
              ID: /usr/bin/alkuskriptit.sh
        Function: file.managed
          Result: True
         Comment: File /usr/bin/alkuskriptit.sh updated
         Started: 09:11:41.293974
        Duration: 82.545 ms
         Changes:
                  ----------
                  diff:
                      ---
                      +++
                      @@ -1,13 +1,13 @@
                       #!/usr/bin/bash

                      -echo("Päivitetään paketit")
                      +echo"Päivitetään paketit"
                       sudo apt-get update

                      -echo("Asennetaan Apache webpalvelin")
                      +echo"Asennetaan Apache webpalvelin"
                       sudo apt-get install apache2 -y

                      -echo("Asennetaan MariaDB tietokanta")
                      +echo"Asennetaan MariaDB tietokanta"
                       sudo apt-get install MariaDB -y

                      -echo("Asennetaan Python ohjelmointikieli")
                      +echo"Asennetaan Python ohjelmointikieli"
                       sudo apt-get install python3

    Summary for minioni
    ------------
    Succeeded: 1 (changed=1)
    Failed:    0
    ------------
    Total states run:     1
    Total run time:  82.545 ms

Tämän jälkeen skriptien ajo minionkoneella onnistui `bash alkuskriptit.sh`! Paitsi MariaDB,
joka ei yllättänyt. Tämä on minulle uusi ja todennäköisesti väärällä nimellä, sillä en kyseiseen tietokantaan ole vielä perehtynyt.
Tarkisin minionilla, että Apachen ja Pythonin asetushakemistot löytyy.

    vagrant@minioni:/etc/apache2$ cd /etc/python3
    vagrant@minioni:/etc/python3$ cd
    vagrant@minioni:~$ cd /etc/apache2
    vagrant@minioni:/etc/apache2$ ls
    apache2.conf    conf-enabled  magic           mods-enabled  sites-available
    conf-available  envvars       mods-available  ports.conf    sites-enabled
    vagrant@minioni:/etc/apache2$ cd /etc/python3
    vagrant@minioni:/etc/python3$ ls
    debian_config

Lopuksi kävin vielä korjaamassa kirjoitusvirheitä ja lisäsin asennettavaksi myös micron. Vaihdoin samalla tietokannan PostgreSQL, sillä se on itselle tutumpi. Eli lopullinen alkuskriptititiedosto tällä hetkellä näyttää tältä:

![image](https://user-images.githubusercontent.com/111494018/205601643-47a813c4-1067-4a58-a82d-5cb8112727ad.png)

Ja init.sls tiedosto tällä hetkellä näyttää tältä:

![image](https://user-images.githubusercontent.com/111494018/205601459-bd0a1833-3b5c-4f04-8591-fdc6ffff48d5.png)

Nyt tuhosin minion koneeni ja asensin uuden minionin ja testasin tilan ja skriptien ajoa tyhjälle minion2 koneelle. Ei tullut ongelmia ja ajokin näytti siistimmältä! Myös PostrgeSQL asentui.

    vagrant@minioni2:~$ cd /etc/postgresql
    vagrant@minioni2:/etc/postgresql$ ls
    13
    vagrant@minioni2:/etc/postgresql$ cd /etc/apache2
    vagrant@minioni2:/etc/apache2$ ls
    apache2.conf    conf-enabled  magic           mods-enabled  sites-available
    conf-available  envvars       mods-available  ports.conf    sites-enabled
    vagrant@minioni2:/etc/apache2$ cd /etc/python3
    vagrant@minioni2:/etc/python3$ ls
    debian_config


## Apache2 konfigurointi

Seuraavaksi lähden tarkemmin muokkaamaan Apachen asennusta. Yritin minion2 koneella tarkastaa curlin avulla Apachen oletussivua `curl localhost`, mutta curlia ei ole asennettuna. Kävin sen lisäämässä herrakoneen alkuskripteihin mukaan asentumaan, jotta ensi kerralla se asentuu automaattisesti. Nyt asensin curlin tähän koneelle manuaalisesti. Nyt `curl localhost` näyttää pitkää html koodiriviä Apachen oletussivuun. Itse nettiselaimella en pysty sivua näyttämään, sillä Vagrant virtuaalikoneessa on vain komentokehote, ei graafista käyttöliittymää. Seuraavaksi pitäisikin herrakoneelta lähteä määrittämään Apachen oletussivun muutoksia ja muokata oletussivu. Lisäksi käyttäjän kotisivut olisi hyvä saada toimimaan.

Loin herrakoneen srv/salt hakemistoon apachetilan `sudo mkdir apache`, jonka sisälle loin init.sls asetustiedoston `sudo micro init.sls`, jonka sisälle asetukset määritellään. Apachen oletussivu löytyy aina paikasta ja tiedostosta /var/wwww/html/index.html. 
Joten lähdin tilan avulla tuota index.html tiedostoa muuttamaan file.managed funktion avulla. Lisäsin tiedostoon alla olevat tiedot. Eli muokataan jo löytyvää index.html tiedostoa, muokkaamalla sen sisällöksi "Hello World". 

![image](https://user-images.githubusercontent.com/111494018/205614251-f527ec5b-9150-4d33-bcd6-7eba6ed1dfdd.png)

Tämän jälkeen ajoin apachetilan minion2 koneelleni `sudo salt '*' state.apply apache`. Tilan ajo onnistui Saltin mukaan ilmon ongelmia. Kävin minion2 koneella testaamssa localhostin uudestaan `curl localhost` ja localhost oli nyt muuttunut "Hello World", eli Apachen oletussivu ei ole enää näkyvissä. Eli tältä osin apachetila on kunnossa.

    vagrant@minioni2:~$ curl localhost
    Hello World

Seuraavaksi lähdin käyttäjän kotisivujen konfiguroinnin kimppuun.

