#!/usr/bin/bash

echo "Testataan Apachen oletussivu"
curl localhost

echo "Testataan käyttäjän kotisivut"
curl localhost/~vagrant/index.html

echo "Testataan PostgreSQL asennus"
psql
echo "Mikäli sait ilmoituksen 'psql: error: FATAL: role vagrant does not exist', 
on PostgreSQL asentunut, mutta käyttäjää ei ole luotu."

echo "Katsotaan tulimuurin tilanne"
sudo ufw status

echo "Pythonia pääset testaamaan komennolla python3"


