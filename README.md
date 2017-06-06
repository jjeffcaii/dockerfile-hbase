# dockerfile-hbase
Dockerfile for HBase on marathon.

## Deployment

**You must mount `hdfs-site.xml`,`core-site.xml` at `/etc/hadoop`.**

Here are some marathon json files.

### Master

``` json
{
  "id": "/hbase/master",
  "args": [ "master" ],
  "instances": 1,
  "cpus": 0.5,
  "mem": 1024,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "jjeffcaii/hbase:1.2",
      "forcePullImage": true
    }
  },
  "portDefinitions": [
    {
      "port": 0,
      "protocol": "tcp",
      "name": "http"
    },
    {
      "port": 0,
      "protocol": "tcp",
      "name": "rpc"
    }
  ],
  "env": {
    "HBASE_QUORUM": "1.zk.lan,2.zk.lan,3.zk.lan,4.zk.lan,5.zk.lan",
    "TZ": "Asia/Shanghai",
    "JAVA_OPTS": "-Xmx1G -Xms1G"
  }
}
```

### Backup Master

``` json
{
  "id": "/hbase/slave",
  "args": [ "master", "--backup" ],
  "instances": 1,
  "cpus": 0.5,
  "mem": 1024,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "jjeffcaii/hbase:1.2",
      "forcePullImage": true
    }
  },
  "portDefinitions": [
    {
      "port": 0,
      "protocol": "tcp",
      "name": "http"
    },
    {
      "port": 0,
      "protocol": "tcp",
      "name": "rpc"
    }
  ],
  "env": {
    "HBASE_QUORUM": "1.zk.lan,2.zk.lan,3.zk.lan,4.zk.lan,5.zk.lan",
    "TZ": "Asia/Shanghai",
    "JAVA_OPTS": "-Xmx1G -Xms1G"
  }
}
```

### Region Server

``` json
{
  "id": "/hbase/regionserver",
  "args": [ "region" ],
  "instances": 4,
  "cpus": 2,
  "mem": 4096,
  "constraints": [ [ "hostname", "UNIQUE" ] ],
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "jjeffcaii/hbase:1.2",
      "forcePullImage": true
    }
  },
  "portDefinitions": [
    {
      "port": 0,
      "protocol": "tcp",
      "name": "http"
    },
    {
      "port": 0,
      "protocol": "tcp",
      "name": "rpc"
    }
  ],
  "env": {
    "HBASE_QUORUM": "1.zk.lan,2.zk.lan,3.zk.lan,4.zk.lan,5.zk.lan",
    "TZ": "Asia/Shanghai"
  }
}
```

### Thrift2 Server (Optional)

``` json
{
  "id": "/hbase/thrift",
  "args": [ "thrift2" ],
  "instances": 1,
  "cpus": 0.5,
  "mem": 1024,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "jjeffcaii/hbase:1.2",
      "network": "HOST",
      "forcePullImage": true
    }
  },
  "portDefinitions": [
    {
      "port": 0,
      "protocol": "tcp",
      "name": "http"
    },
    {
      "port": 0,
      "protocol": "tcp",
      "name": "rpc"
    }
  ],
  "env": {
    "HBASE_QUORUM": "1.zk.lan,2.zk.lan,3.zk.lan,4.zk.lan,5.zk.lan",
    "TZ": "Asia/Shanghai",
    "JAVA_OPTS": "-Xmx1g -Xms1g"
  }
}
```


## FAQ

- Q: How to graceful stop a regionserver?

> A: Killing a regionserver directly is **NOT SAFE**! First, you must enter docker container, and then execute `$HBAE_HOME/bin/hbase-daemon.sh stop regionserver`.

- Q: Can I use bridge network?

> A: NO! Host network **ONLY**!
