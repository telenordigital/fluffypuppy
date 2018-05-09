#!bin/bash

cp -r /opt/scout2/templates/* /opt/scout2/scout2-report
export AWS_ACCESS_KEY_ID=$(sed -n '2p' /root/.aws/credentials | sed 's:.*=::')
export AWS_SECRET_ACCESS_KEY=$(sed -n '3p' /root/.aws/credentials | sed 's:.*=::')
python /opt/scout2/fp-automation.py -c /root/.aws/config -s /opt/scout2 -t 24
