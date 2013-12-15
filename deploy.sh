#!/bin/bash

set -eux

./clean_and_create_static_files.sh
#ssh krijgerzeefdruk rm -rf Webhosting/tmp
rsync -aHAXxv --checksum --numeric-ids --delete --progress -e "ssh -T -o Compression=no -x" out/* krijgerzeefdruk:Webhosting/tmp
ssh krijgerzeefdruk "cd Webhosting && ./deploy.sh"

