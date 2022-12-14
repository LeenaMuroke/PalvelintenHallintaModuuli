# PalvelintenHallintaModuuli

Tämä on Haaga-Helia ammattikorkeakoulun kurssin "Palvelinten hallinta" loppuprojektin varasto. 
Projektin tarkoituksena on konfiguroida uusi virtuaalikone käyttökuntoon omia projekteja varten. 

Moduuli asentaa uudelle virtuaalikoneella Apachen käyttökuntoon, sekä muita hyödyllisiä paketteja: tulimuurin, curl, micro, python3, PostgreSQL tietokanta.

## Lisenssi 

GNU General Public License v3.0

## Moduulin toteutus

Moduulia tällä hetkellä ohjataan Saltin avulla herrakoneeltani yhdistetyille minionkoneille.
Tästä GitHubista löytyvät Salt-tiedostot voi kuitenkin ladata itselleen ja asentaa itse manuaalisesti salt-master ja salt-minionin,
ja ajaa tiloja paikallisesti. 

## Moduulin ajo virtuaalikoneella

1. Ensiksi kuuluu ajaa minionkoneella `bash alkuskriptit.sh`, joka asentaa tarvittavia paketteja: päivittää paketit, asentaa ja konfiguroi tulimuuria, asentaa curl ja micro. 

2. Aja apache ja python tilat herraokoneelta minionkoneelle `sudo salt '*' state.apply`´

3. Testaa asennetut ohjelmat ja paketit ajamalla testiskriptit `bash testiskriptit.sh`

<img width="503" alt="image" src="https://user-images.githubusercontent.com/111494018/207537215-b125e696-027e-475a-974c-a6770b270e7e.png">

## Moduulin teko 

Koko moduulin teko on raportoitu omaan raporttiinsa, joka löytyy tästä varastosta.
Suora linkki raporttiin: https://github.com/LeenaMuroke/PalvelintenHallintaModuuli/blob/main/Raportti.md

