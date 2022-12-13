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

Muiden moduuleista innostuneena, päätän lähteä yrittämään LAPP-moduulia, jonka avulla konfiguroidaan uusia koneita.
LAMP tulee sanoista L = Linux käyttöjärjstelmä, A = Apache webpalvelin, P = PostgreSQL tietokanta (raportissa kokeiltu myös MariaDB) ja P = Python ohjelmointikieli.
Moduulia tullaan ajamaan Saltin avulla herra ja minionkoneiden välillä. 
Eli moduuli asentaa tarvittavat välineet aloittaa tekemään omia koodaustehtäviä. 
Valitsin tämän, sillä koen tästä olevan itselle hyötyä omiin projekteihini. 
Lisäksi tässä on sopivan verran tuttua mutta myös uutta haastetta.
Lisäksi asennan kaikkea muuta matkan varrella tullutta tarpeellista ohjelmaa.

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
Ensiksi tarkistin curlin avulla käyttäjän kotisivun nykyisen tilan 
`curl localhost/~vagrant`. HTML-koodista pystyy päättelemään, ettei saa yhteyttä.

    Kvagrant@minioni2:~$ curl localhost/~vagrant
    <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
    <html><head>
    <title>404 Not Found</title>
    </head><body>
    <h1>Not Found</h1>
    <p>The requested URL was not found on this server.</p>
    <hr>
    <address>Apache/2.4.54 (Debian) Server at localhost Port 80</address>
    </body></html>

Samalla tajusin, ettei koneelle ole asennettuna palomuuria. Lisäsin palomuurin asennuksen alkuskripteihin, 
ja sallin http liikenteen portille 80. Minionille asensin nämä nyt manuaalisesti samalla tavalla.

Seuraavaksi loin apachetilaan käyttäjän kotisivuille hakemiston public_html ja sen sisään
itse kotisivutiedoston index.html. Index.html kirjoitin pelkän "Hello World". Myöhemmin toimiessa tämän voisi vaihtaa
validiksi html-sivun pohjaksi. Muokkasin apachetilan init.sls, jotta samat tiedot luodaan minionillekin.
Samalla sallin käyttäjien kotisivut, sekä että, apache käynnistyy uudelleen muutosten jälkeen.

    /etc/apache2/mods-enabled/userdir.conf:
     file.symlink:
       - target: ../mods-available/userdir.conf
    /etc/apache2/mods-enabled/userdir.load:
     file.symlink:
       - target: ../mods-available/userdir.load
    apache2service:
     service.running:
       - name: apache2
       - watch:
         - file: /etc/apache2/mods-enabled/userdir.conf
         - file: /etc/apache2/mods-enabled/userdir.load

Yritin ajaa herralta tilan minionille, mutta mikään ei muuttunut. Yritin kirjautua ulos.
Samalla tajusin, etten palomuurissa ole sallinut ssh yhteyttä. Eli enpä pääse enää sen avulla takaisin koneelle.
Lisäsin alkuskripteihin SSH-yhteyden sallimisen portille 22. Tuhosin minionin useamman kerran tilojen ajamisien välissä lukuisten virheiden takia. Lopulta kuitenkin sain palomuurit ja apachen kotisivut toimimaan seuraavanlaisesti. Lisäsin esim. palomuuriin sallitut portit 4505 ja 4506, joita Salt käyttää. Loin hakemiston ja tiedoston kotisvuille "Hello World" sisällöllä. Kyseiset tiedostot tulevat käyttäjän kotihakemistoon, joita voi myöhemmin itse muokata haluamanlaisiksi.

Alkuskriptit:

<img width="208" alt="image" src="https://user-images.githubusercontent.com/111494018/206843259-953ea147-ef72-453c-89ff-72946484976e.png">

Apachen init.sls:

<img width="197" alt="image" src="https://user-images.githubusercontent.com/111494018/206843277-9b95742b-33a5-4a9d-a306-fbb2d8665a1b.png">

Minionikoneella tein testejä. Palomuuri on toiminnassa ja halutut portit sallittu.

    vagrant@minioni4:~$ sudo ufw status
    Status: active

    To                         Action      From
    --                         ------      ----
    80/tcp                     ALLOW       Anywhere
    22/tcp                     ALLOW       Anywhere
    4505/tcp                   ALLOW       Anywhere
    4506/tcp                   ALLOW       Anywhere
    80/tcp (v6)                ALLOW       Anywhere (v6)
    22/tcp (v6)                ALLOW       Anywhere (v6)
    4505/tcp (v6)              ALLOW       Anywhere (v6)
    4506/tcp (v6)              ALLOW       Anywhere (v6)
    
Apachen oletussivu on päivittynyt, samoiten käyttäjän kotisivut.

    vagrant@minioni4:~$ curl localhost
    Hello world
    vagrant@minioni4:~$ curl localhost/~vagrant/index.html
    Hello World

## Tietokanta PostgreSQL

Lennosta vaihdoin tietokannaksi PostgreSQL, koska se on itselle tutumpi tietokanta. 
Loin tälle oman postgresql-nimisen tilan Salttiin, jonka sisälle loin init.sls tiedoston. 
Sinne määritin postgreSQL asentuvaksi pkg.installed funktiolla.  
Poistin postgresqln minionilta `sudo apt-get purge postgre*` ja ajoin postgresql tilan herralta minionille.
Sain kuitenkin sellaisen ilmoituksen, mitä en osannut debugata. 

    vagrant@herra:/srv/salt$ sudo salt '*' state.apply postgresql
    minioni4:
    ----------
              ID: postgresql
        Function: pkg.installed
          Result: False
         Comment: An error was encountered while installing package(s): E: Release file for https://deb.debian.org/debian/dists/bullseye-updates/InRelease is not valid yet (invalid for another 2d 22h 21min 8s). Updates for this repository will not be applied.
                  E: Release file for https://security.debian.org/debian-security/dists/bullseye-security/InRelease is not valid yet (invalid for another 2d 12h 1min 0s). Updates for this repository will not be applied.
                  E: Release file for https://deb.debian.org/debian/dists/bullseye-backports/InRelease is not valid yet (invalid for another 2d 22h 21min 7s). Updates for this repository will not be applied.
         Started: 09:52:22.990119
        Duration: 2477.147 ms
         Changes:

    Summary for minioni4
    ------------
    Succeeded: 0
    Failed:    1
    ------------
    Total states run:     1
    Total run time:   2.477 s
    ERROR: Minions returned with non-zero exit code
    
Päätin vaihtaa tietokantaa MariaDB:ksi, jotta saan jonkun tietokannan asennettua. 
Poistin postgretilan, ja loin tilalle mariadb tilan. Sain kuitenkin samanlaisen ilmoituksen 
kuin Postgren kohdalla. 

    vagrant@herra:/srv/salt$ sudo salt '*' state.apply mariadb
    minioni4:
    ----------
              ID: mariadb
        Function: pkg.installed
          Result: False
         Comment: An error was encountered while installing package(s): E: Release file for https://deb.debian.org/debian/dists/bullseye-updates/InRelease is not valid yet (invalid for another 2d 22h 13min 39s). Updates for this repository will not be applied.
                  E: Release file for https://security.debian.org/debian-security/dists/bullseye-security/InRelease is not valid yet (invalid for another 2d 11h 53min 31s). Updates for this repository will not be applied.
                  E: Release file for https://deb.debian.org/debian/dists/bullseye-backports/InRelease is not valid yet (invalid for another 2d 22h 13min 38s). Updates for this repository will not be applied.
         Started: 09:59:52.003715
        Duration: 2127.755 ms
         Changes:

    Summary for minioni4
    ------------
    Succeeded: 0
    Failed:    1
    ------------
    Total states run:     1
    Total run time:   2.128 s
    ERROR: Minions returned with non-zero exit code


Sama ilmoitus tuli myös paikallisesti ajettaessa tilaa herralle. 
Päätin tässä kohti Postgren asentumaan pelkästä alkuskriptista ilman muita konfiguraatioita.
Poistin mariadb tilan.

## Python ohjelmointikieli

Itse paketinasennus python ohjelmointikielestä on jo suoritettu alkuskriptien ajon aikana. 
Kävin  testaamassa, että python on asentunut. 
Komennolla `python3` pääsee ajamaan pythonia. 
Kokeilin helppoja juttuja, kuten ruudulle printtaamista, perus matematiikkaa. 
Kaikki toimi! 

    vagrant@minioni4:~$ python3
    Python 3.9.2 (default, Feb 28 2021, 17:03:44)
    [GCC 10.2.1 20210110] on linux
    Type "help", "copyright", "credits" or "license" for more information.
    >>> print("Hello")
    Hello
    >>> 5+5
    10
    >>> f"Moikkamoi {1+5}"
    'Moikkamoi 6'
    >>>


Koska tietokannan asennus tilana epäonnistui, päätin asentaa moduulissa python kielen tilana.
Jotta voin tiloilla harjoitella myös top.sls käyttöä, joka ajaa useamman tilan samanaikaisesti.
Eli loin Saltiin python nimisen tilan, ja sen init.sls tiedostoon määritin pkg.installed funktiolla asentavan python3 paketin.

<img width="149" alt="image" src="https://user-images.githubusercontent.com/111494018/207368107-c625f8f6-df38-417a-88ed-961c1f8c8ad2.png">

Poistin minionkoneelta pythonin `sudo apt-get purge python*` ja 
ajoin herralta python tilan minionille. Tilan ajo ei kuitenkaan onnistunut. (Tästä unohdin ottaa heti kuvan/koodin talteen, ja kohta olinkin jo tuhonnut koko minion koneen, eli ei enää onnistunut sitä kaivaa esille.)

Mitkään muutkaan tilanajot ei enää onnistunut, ja päättelin, että olin tuhonnut jo liikaa asioita.
Herra ei enää saanut yhteyttä minioniin. Tein uuden virtuaalikoneen, ja salt-minionia asentaessa siihen tajusin asennusteksteistä,
että python2 asentuu automaattisesti sen yhteydessä. Salt-minion asennuksen jälkeen testasinkin pythonia, ja se oli jo toiminnassa.
Jätin kuitenkin luomani python tilan, jotta voin harjoitella top.sls tilan käyttöä apachen ja pythontilan kanssa.
Testasinkin ajaa herralta python tilan minionille, ja sain ilmoituksen paketin olevan jo asennettu.

    vagrant@herra:/srv/salt/python$ sudo salt '*' state.apply python
    minioni5:
    ----------
              ID: python3
        Function: pkg.installed
          Result: True
         Comment: All specified packages are already installed
         Started: 14:49:09.501680
        Duration: 35.268 ms
         Changes:

    Summary for minioni5
    ------------
    Succeeded: 1
    Failed:    0
    ------------
    Total states run:     1
    Total run time:  35.268 ms
    ## Muutokset Apacheen

Vaihdoin asennuksen tapahtumaan apachetilan init.sls tiedostoon pkg.installed funktiolla.
Poistin asennuksen alkuskripteistä.

## Top.sls tila

Halusin niputtaa yhteen apachen ja pythontilan, jotta voin harjoitella top.sls tilan käyttöä.
Tällöin riittää ajaa vain yksi komento, joka asentaa molemmat tilat.
Loin ensiksi saltiin tiedoston top.sls. Sen sisään määritin, että kun ajetaan kaikki '*', niin ajetaan apavhe ja pythontilat.

    vagrant@herra:/srv/salt$ sudo salt '*' state.apply
    minioni5:
    ----------
              ID: apache2
        Function: pkg.installed
          Result: True
         Comment: All specified packages are already installed
         Started: 14:53:31.074731
        Duration: 46.577 ms
         Changes:
    ----------
              ID: /var/www/html/index.html
        Function: file.managed
          Result: True
         Comment: File /var/www/html/index.html is in the correct state
         Started: 14:53:31.127752
        Duration: 20.349 ms
         Changes:
    ----------
              ID: /etc/apache2/mods-enabled/userdir.conf
        Function: file.symlink
          Result: True
         Comment: Symlink /etc/apache2/mods-enabled/userdir.conf is present and owned by root:root
         Started: 14:53:31.148264
        Duration: 1.794 ms
         Changes:
    ----------
              ID: /etc/apache2/mods-enabled/userdir.load
        Function: file.symlink
          Result: True
         Comment: Symlink /etc/apache2/mods-enabled/userdir.load is present and owned by root:root
         Started: 14:53:31.150198
        Duration: 2.065 ms
         Changes:
    ----------
              ID: /home/vagrant/public_html
        Function: file.recurse
          Result: True
         Comment: The directory /home/vagrant/public_html is in the correct state
         Started: 14:53:31.152468
        Duration: 78.373 ms
         Changes:
    ----------
              ID: apache2.service
        Function: service.running
            Name: apache2
          Result: True
         Comment: The service apache2 is already running
         Started: 14:53:31.233876
        Duration: 66.224 ms
         Changes:
    ----------
              ID: python3
        Function: pkg.installed
          Result: True
         Comment: All specified packages are already installed
         Started: 14:53:31.300491
        Duration: 14.205 ms
         Changes:

    Summary for minioni5
    ------------
    Succeeded: 7
    Failed:    0
    ------------
    Total states run:     7
    Total run time: 229.587 ms

Ajoin Saltista herralla pelkän `sudo salt '*' state.apply`, eli en määritellyt mitä tilaa ajetaan.
Näin ollen se luki top.sls tiedostosta mitä halutaan ajaa.
Apache ja python tilat molemmat ajettiin saman aikaisesti. Tosin muutoksia ei tullut, sillä molemmat olen jo erikseen ehtinyt testata.

## Testiskriptit

Lopuksi haluaisin vielä toteuttaa automaattiset testiskriptit, jotta tilojen ajojen jälkeen voi helposti testata, että kaikki on oikeasti asentunut niinkuin pitää. Loin siis saltiin testiskriptit tilan, jonka sisälle lähdin määrittämään mitä testauksia tehdään. Toteutuin tätä aika samalla tavalla kuin alkuskriptejä eli echolla kerrotaan mitä tapahtuu, ja skriptataan skriptit millä testataan. 

<img width="377" alt="image" src="https://user-images.githubusercontent.com/111494018/207373580-6435d9ec-d113-4daf-ae19-4348a8f87273.png">

Loin tilaan init.sls tiedoston, johon alkuskriptien tapaan määritin, että testiskriptitiedoston pitää asentua /usr/bin/ hakemistoon, jotta sitä voidaan bashin avulla ajaa mistä tahansa koneelta. 

<img width="269" alt="image" src="https://user-images.githubusercontent.com/111494018/207373814-86319fb5-4454-47fc-b438-613d8628525e.png">

Ajoin herralta testiskriptit tilan minionille ja minionilla testasin ajaa ne `bash testiskriptit.sh`. 
   
       vagrant@minioni5:~$ bash testiskriptit.sh
        Testataan Apachen oletussivu
        Hello world
        Testataan käyttäjän kotisivut
        Hello World
        Testataan PostgreSQL asennus
        psql: error: FATAL:  role "vagrant" does not exist
        Mikäli sait ilmoituksen 'psql: error: FATAL: role vagrant does not exist', on PostgreSQL asentunut, mutta käyttäjää ei ole luotu.
        Testataan python ohjelmointikieli
        Python 3.9.2 (default, Feb 28 2021, 17:03:44)
        [GCC 10.2.1 20210110] on linux
        Type "help", "copyright", "credits" or "license" for more information.
        >>>
        
Kaikki toimi niin kuin pitääkin. PostgeSQL on asennettu, mutta sinne ei pääse sisään, koska käyttäjää sinne ei ole luotuna.
Python3 aukeaa terminaaliin, mutta suoraan näillä skripteillä ei voi siihen suorittaa testejä. Päätin vaihtaa niin, että echolla vain kerrotaan miten pythonia voi testata. Eli lopulliset skriptit ovat: 

<img width="377" alt="image" src="https://user-images.githubusercontent.com/111494018/207373737-a41b25ca-f57b-4e31-a55b-d9c2df3a5653.png">

Lisäsin vielä tulimuurin testauksen mukaan skripteihin.

<img width="179" alt="image" src="https://user-images.githubusercontent.com/111494018/207381879-fe583fe2-ae15-46d7-b4a4-689f892acb39.png">


## Kaiken testaaminen tyhjällä koneella

Loin Vagrantilla vielä yhden uuden virtuaalikoneen minion6, jotta voin kaiken testata puhtaalta pöydältä. 
Ajoin minionille valmiiksi alkuskriptit ja testiskriptit `sudo salt '*' state.apply alkuskriptit` ja `sudo salt '*' state.apply testiskriptit`. Nämä kun ei itsessään tee vielä mitään, ennen kuin skriptit ajetaan koneella bashin avulla. Molemmat asentuivat Saltin mukaan koneelle.

<img width="325" alt="image" src="https://user-images.githubusercontent.com/111494018/207381055-f0ed058e-c98d-4121-9717-e0e6d12c64d4.png">

<img width="317" alt="image" src="https://user-images.githubusercontent.com/111494018/207381169-2b827d40-e71d-4843-9d1f-4a2669dab033.png">

Seuraavaksi minionkoneella ajoin alkuskritptit `bash alkuskriptit.sh`. 
Yritin ajaa top.sls `sudo salt '*' state.apply`, mutta sain ilmoituksen:

<img width="407" alt="image" src="https://user-images.githubusercontent.com/111494018/207385244-76b5439f-a2c1-4aef-8135-8ed306d0c96d.png">

Tähän kuitenkin auttoi, kun käynnistin minionin uudestaan `sudo systemctl restart salt-minion`.
Tilan ajo ei kuitenkaan onnistunut. Sain tilat kuitenkin ajettua erikseen `sudo salt '*' state.apply apache` ja `sudo salt '*' state.apply python`. Molemmista sain kuitenkin ilmoitukset, että kaikki on jo oikeassa jamassa. Eli vissiin oli jo aiemmin ajot onnistunut silti.

              ID: /var/www/html/index.html
        Function: file.managed
          Result: True
         Comment: File /var/www/html/index.html is in the correct state
         Started: 16:13:34.339245
        Duration: 16.044 ms
         Changes:
    ----------
              ID: /etc/apache2/mods-enabled/userdir.conf
        Function: file.symlink
          Result: True
         Comment: Symlink /etc/apache2/mods-enabled/userdir.conf is present and owned by root:root
         Started: 16:13:34.355390
        Duration: 1.534 ms
         Changes:
    ----------
              ID: /etc/apache2/mods-enabled/userdir.load
        Function: file.symlink
          Result: True
         Comment: Symlink /etc/apache2/mods-enabled/userdir.load is present and owned by root:root
         Started: 16:13:34.357000
        Duration: 1.245 ms
         Changes:
    ----------
              ID: /home/vagrant/public_html
        Function: file.recurse
          Result: True
         Comment: The directory /home/vagrant/public_html is in the correct state
         Started: 16:13:34.358325
        Duration: 64.437 ms
         Changes:
    ----------
              ID: apache2.service
        Function: service.running
            Name: apache2
          Result: True
         Comment: The service apache2 is already running
         Started: 16:13:34.424607
        Duration: 64.417 ms
         Changes:

    Summary for minioni6

    vagrant@herra:/srv/salt/alkuskriptit$ sudo salt '*' state.apply python
    minioni6:
    ----------
              ID: python3
        Function: pkg.installed
          Result: True
         Comment: All specified packages are already installed
         Started: 16:13:43.760775
        Duration: 63.491 ms
         Changes:

Tilojen ajon jälkeen tein testiskriptit `bash testiskriptit.sh`. Apachen sivut toimii, PostgreSQL on asennettuna ja tulimuuri mallillaan.

<img width="320" alt="image" src="https://user-images.githubusercontent.com/111494018/207386551-a61d1085-c9dd-459c-a7ce-897ab76461d3.png">

## Lopullisen asennustiedostot moduuliin

Viimeisimmät versiot olen ladannut versionhallinnalla tänne GitHubiin. Eli skriptitiedostot ja Salt tiedostot löytyvät samasta reposta kuin tämä raportti https://github.com/LeenaMuroke/PalvelintenHallintaModuuli/



       
