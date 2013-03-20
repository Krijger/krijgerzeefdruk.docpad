#!/bin/bash
sudo rm -rf out
docpad generate --env static
sudo chown -R ${USER}:www-data out
sudo find out -type d -exec chmod u=rwx,g=rx,o= {} \;
sudo find out -type f -exec chmod u=rw,g=r,o= {} \;
