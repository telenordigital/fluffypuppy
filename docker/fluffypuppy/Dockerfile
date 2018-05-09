FROM python:2.7

RUN apt-get update && apt-get install -y \
    git \
    python-pip

RUN git clone --branch v3.0.5 https://github.com/nccgroup/Scout2 /opt/scout2

WORKDIR /opt/scout2

RUN pip install -r requirements.txt
RUN python setup.py install

RUN pip install awscli

COPY .aws/config /root/.aws/config
COPY .aws/credentials /root/.aws/credentials
COPY custom-ruleset.json AWSScout2/rules/data/rulesets/custom-ruleset.json
COPY custom-ruleset.json /usr/local/lib/python2.7/site-packages/AWSScout2-3.0.5-py2.7.egg/AWSScout2/rules/data/rulesets/custom-ruleset.json
COPY fp-automation.py .
RUN mkdir -p /opt/scout2/scout2-report
COPY templates/* /opt/scout2/templates/
COPY entrypoint.sh /opt/scout2/entrypoint.sh
RUN chmod +x entrypoint.sh

CMD ["sh","entrypoint.sh"]
