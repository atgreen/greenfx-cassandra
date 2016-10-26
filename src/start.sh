#!/usr/bin/env bash

# Accept listen_address
IP=${LISTEN_ADDRESS:-`hostname --ip-address`}

echo Configuring Cassandra to listen at $IP with seeds $SEEDS

# Setup Cassandra
DEFAULT=${DEFAULT:-/etc/cassandra/default.conf}
CONFIG=/etc/cassandra/conf

rm -rf $CONFIG && cp -r $DEFAULT $CONFIG
sed -i -e "s/^start_rpc.*/start_rpc: true/"           $CONFIG/cassandra.yaml
sed -i -e "s/^listen_address.*/listen_address: $IP/"            $CONFIG/cassandra.yaml
sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/"              $CONFIG/cassandra.yaml
sed -i -e "s/# broadcast_address.*/broadcast_address: $IP/"              $CONFIG/cassandra.yaml
sed -i -e "s/# broadcast_rpc_address.*/broadcast_rpc_address: $IP/"              $CONFIG/cassandra.yaml
sed -i -e "s/^commitlog_segment_size_in_mb.*/commitlog_segment_size_in_mb: 64/"              $CONFIG/cassandra.yaml

sed -i -e "s/# JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=<public name>\"/JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=$IP\"/" $CONFIG/cassandra-env.sh
sed -i -e "s/LOCAL_JMX=yes/LOCAL_JMX=no/" $CONFIG/cassandra-env.sh
sed -i -e "s/JVM_OPTS=\"\$JVM_OPTS -Dcom.sun.management.jmxremote.authenticate=true\"/JVM_OPTS=\"\$JVM_OPTS -Dcom.sun.management.jmxremote.authenticate=false\"/" $CONFIG/cassandra-env.sh

# Start process
echo Starting Cassandra on $IP...
cassandra -f

