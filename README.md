# MojoMVC
Mojolicious MVC Framework

Template for a Perl (Mojolicious) Microservice

Features:
- Mojolicious
- SQLite
- ZeroMQ
- RabbitMQ
- Swagger/OpenAPI
- Unit Testing
- Docker (x86 and ARM)
- Docker-Compose
- Travis CI
- MongoDB

Build package:

```
$ perl Makefile.PL
$ make test
$ make manifest
$ make dist
```

Run application:

```
$ morbo script/my_app
```

Run test:

```
$ perl script/my_app test
```

Access swagger API definition:

```
$ curl http://<ip_address>:<port_no>/api
```

Access sample REST API method:

```
$ curl http://<ip_address>:<port_no>/api/sample
```