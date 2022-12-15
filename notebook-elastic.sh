#!/bin/bash

echo "Install packages. Update pip and install/update docker-compose."
python3 -m venv venv
. venv/bin/activate && python3 -m pip install -U pip > /dev/null
. venv/bin/activate && python3 -m pip install -U docker-compose > /dev/null

[[ ! -d ./demo/docker-elk ]] && git clone https://github.com/deviantony/docker-elk.git ./demo/docker-elk

sed -i -e 's/changeme/password/' ./demo/docker-elk/.env
sed -i -e 's/ELASTIC_VERSION=.*/ELASTIC_VERSION=8.5.3/' ./demo/docker-elk/.env
sed -i -e 's/trial/basic/' ./demo/docker-elk/elasticsearch/config/elasticsearch.yml
sed -i -e 's/xpack.security.enabled: true/xpack.security.enabled: false/' ./demo/docker-elk/elasticsearch/config/elasticsearch.yml

if ! grep rss ~/docker-elk/logstash/Dockerfile > /dev/null ; then
    echo "RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-rss" >> \
        ~/docker-elk/logstash/Dockerfile
    CURRENT="$(pwd)"
    cd ~/docker-elk || exit
    docker-compose build
    cd "${CURRENT}" || exit
fi

if grep LOGSTASH ~/docker-elk/logstash/pipeline/logstash.conf > /dev/null ; then
    sed -i -e 's/password => .*/password => "password"/' ~/docker-elk/logstash/pipeline/logstash.conf
fi

echo "Open a terminal and run 'docker-compose up' in ~/docker-elk/."
echo ""
read -rp "Press enter when done." dummy
echo ""
echo "Open http://localhost:5601/app/dev_tools#/console and insert:"
echo ""
cat ~/rss-security/templates/rss-component_template.json
echo ""
echo ""
read -rp "Press enter when done." dummy
echo ""
cat ~/rss-security/templates/rss-index_template.json
echo ""
echo ""
read -rp "Press enter when done." dummy
echo ""
echo "Open http://localhost:5601/app/management/kibana/objects and click import."
echo "Open the folder ~/rss-security/kibana/saved_objects/."
echo "Drag the detailed file and import it."
echo ""
read -rp "Press enter when done." dummy
echo "${dummy}" > /dev/null
echo ""
echo "Restart docker with docker-compose restart."
