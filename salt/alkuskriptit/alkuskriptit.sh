#!/usr/bin/bash

echo "Päivitetään paketit"
sudo apt-get update

echo "Asennetaan palomuuri"
sudo apt-get install ufw -y

echo "Laitetaan palomuuri päälle"
sudo ufw enable
y

echo "Sallitaan HTTP-liikenne portille 80"
sudo ufw allow 80/tcp

echo "Sallitaan SSH-yhteys portille 22"
sudo ufw allow 22/tcp

echo "Sallitaan yhteys Saltin porttiin 4505"
sudo ufw allow 4505/tcp

echo "Sallitaan Saltin portille 4506"
sudo ufw allow 4506/tcp

echo "Asennetaan micro editointiohjelma"
sudo apt-get install micro -y

echo "Asennetaan curl ohjelma nettisivujen testaukseen"
sudo apt-get install curl -y

echo "Asennetaan Apache webpalvelin"
sudo apt-get install apache2 -y

echo "Asennetaan PostgreSQL tietokanta"
sudo apt-get install postgresql -y

echo "Asennetaan Python ohjelmointikieli"
sudo apt-get install python3 -y
