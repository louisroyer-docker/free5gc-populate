# Free5GC-populate Docker Images
## dev-free5gc-populate
> [!IMPORTANT]
> This image contains a version of free5gc-populate that is compatible with free5GC v4.0.0, and will eventually be removed once proporly packaged and integrated into `louisroyer/free5gc-populate` image.
> Configuration is identical to `louisroyer/free5gc-populate` image, and described bellow.

> [!WARNING]
> **The following image is NOT an official build of free5GC-populate**, in the future it may include beta-functionalities.

The image is available on DockerHub: [`louisroyer/dev-free5gc-populate`](https://hub.docker.com/r/louisroyer/dev-free5gc-populate)

> [!NOTE]
> Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/free5gc-populate` is provided to you under Apache License.
> A copy of the source code is available at in the repository [`louisroyer/free5gc-populate`](https://github.com/louisroyer/free5gc-populate) on the branch `f5gc4.0`.

## free5gc-populate
> [!WARNING]
> **The following image is NOT an official build of free5GC-populate**, in the future it may include beta-functionalities.

The image is available on DockerHub: [`louisroyer/free5gc-populate`](https://hub.docker.com/r/louisroyer/free5gc-populate)

> [!TIP]
> By default, configuration file from templating is used if no `--config` or `-c` is passed as argument. To start without argument, use:
> ```yaml
> command: [" "]
> ```

With the default templating script, if the environment variable `$MONGO_HOST` is set, `wait-for-it` is started to wait for database before attempting subscriber insertion.
`$MONGO_PORT` can also be used to define the TCP port used by the database if different than the default one.

Environment variable used to select templating system:
```yaml
environment:
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/free5gc-populate/config.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/free5gc-populate/template.yaml"
```

Environment variables for templating:
```yaml
environment:
  MCC: "001"
  MNC: "01"
  KEY: "8baf473f2f8fd09487cccbd7097c6862"
  OP: "8e27b6af0e692e750f32667a3b14605d"
  SQN: "16f3b3f70fc2"
  AMF: "8000"
  # The following variables have no default values
  SLICES: |-
    - sst: 01
      sd: 010203
      varqi: 9
      dnn: internet
    - sst: 01
      sd: 112233
      varqi: 9
      dnn: internet2
      # PDU Sessions Type for this slice
      # possible values are: "IPV4", "IPV6", "IPV4V6", "UNSTRUCTURED", "ETHERNET"
      # when omitted, results in "IPV4"
      pdu-session-type: "IPV4V6"
  IMSI: |-
    - imsi-001010000000001
    - imsi-001010000000002
    - imsi-001010000000003
```

## Quickstart
```yaml
services:
  mongodb-f5gc:
    image: mongo
    container_name: mongodb-f5gc
    hostname: mongodb-f5gc
    restart: "always"
    command: ["mongod", "--port", "27017", "--bind_ip_all"]
    networks:
      db-net:
  free5gc-populate:
    image: louisroyer/free5gc-populate
    container_name: free5gc-populate
    hostname: free5gc-populate
    restart: "no" # oneshot
    command: [" "]
    environment:
      MONGO_HOST: "mongodb-f5gc.db-net"
      SLICES: |-
        - sst: 01
          sd: 010203
          varqi: 9
          dnn: sliceA
      IMSI: |-
        - imsi-001010000000001
        - imsi-001010000000002
    depends_on:
      - mongodb-f5gc
    networks:
      db-net:
networks:
  db-net:
    name: db-net
```
