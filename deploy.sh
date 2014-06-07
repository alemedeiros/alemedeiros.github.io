#!/bin/sh

./homepage rebuild

case $1 in
  ic)
    rsync -az _site/* ic:~/public_html
    ;;
  sdf)
    tar cjf hpg.tar.bz2 -C _site/ .
    echo "put hpg.tar.bz2" | sftp sdf.org
    ssh sdf.org "tar xjf hpg.tar.bz2 -C html; mkhomepg -p; rm hpg.tar.bz2"
    rm hpg.tar.bz2
    ;;
  all|*)
    ./deploy.sh ic
    ./deploy.sh sdf
    ;;
esac
