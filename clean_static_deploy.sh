#!/bin/bash
sudo rm -rf out
docpad generate --env static
cd out
sudo chown -R ${USER}:www-data .
sudo find . -type d -exec chmod u=rwx,g=rx,o= {} \;
sudo find . -type f -exec chmod u=rw,g=r,o= {} \;
cd ..
