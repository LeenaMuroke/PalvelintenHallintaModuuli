#!/usr/bin/bash

echo "Päivitetään paketit"
sudo apt-get update

echo "Asennetaan micro editointiohjelma"
sudo apt-get install micro -y

echo "Asennetaan Apache webpalvelin"
sudo apt-get install apache2 -y

echo "Asennetaan PostgreSQL tietokanta"
sudo apt-get install postgresql -y

echo "Asennetaan Python ohjelmointikieli"
sudo apt-get install python3 -y
