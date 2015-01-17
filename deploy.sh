#!/bin/sh

# specific deploying functions
deploy_ic(){
  rsync -az _site/* ic:~/public_html
}

deploy_sdf(){
  tar cjf hpg.tar.bz2 -C _site/ .
  echo "put hpg.tar.bz2" | sftp sdf.org
  ssh sdf.org "tar xjf hpg.tar.bz2 -C html; mkhomepg -p; rm hpg.tar.bz2"
  rm hpg.tar.bz2
}


# Rebuild page before deploying
cabal run rebuild

# Check if deploy is specific, otherwise, deploy everywhere
case $1 in
  ic)
    deploy_ic
    ;;
  sdf)
    deploy_sdf
    ;;
  all|*)
    deploy_ic
    deploy_sdf
    ;;
esac
