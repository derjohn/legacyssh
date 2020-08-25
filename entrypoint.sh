#!/bin/bash
cp -r /root/.legacyssh /root/.ssh
chown root: -R /root/.ssh
if [ -z ${SSHPASS} ]; then
  ssh $*
else
  sshpass -e ssh $*
fi

