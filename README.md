# SmartPlug API

This project was developed for course PV249 teached on [Faculty of Informatics - Masaryk University](https://www.fi.muni.cz/index.html.en)

This repository contains API implementation for controlling Hexade SmartPlug devices and some sample home management logic. Entire application is written in Ruby language. For REST API implementation is used [Sinatra](http://sinatrarb.com/) framework.

**This is only sample application and does not support all SmartPlug functionality. Application would not be supported in the future**

## Device

Device is base on low-cost [ESP-32 SoC](https://www.espressif.com/en/products/hardware/esp32/overview). The chip integrates WiFi and Bluetooth radio. Device contains accurate measuring integrated circuit and the relay for power switching.

You can find sample web presentation with additional information on: https://www.smartplug.cz/.

## Infrastrucutre

For communication and devices control is used the [Azure IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/) service which is part of the [Azure IoT Solution](https://azure.microsoft.com/cs-cz/services/iot-hub/). For more information read the docs.

REST API needs also any database for bussines logic. I've used [PostgreSQL](https://www.postgresql.org/) in the example. You can change adapters to use any database.

## Modules

The application consists of three main modules.

### IoT Hub service client

This module provides functionality for communication with IoT Hub service. There are implemented libraries for device idnetities, device twins and jobs management. For more information read the IoT Hub docs.

Sources are contained in [/iothub](https://github.com/kyberpunk/smartplug-api/tree/master/iothub) folder.

### SmartPlug management

SmartPlug management is located in [/smartplug](https://github.com/kyberpunk/smartplug-api/tree/master/smartplug) folder and provides logic for SmartPlug devices control and reading measurement data. Measurement data delivery is not real time, but requires polling due to REST API and HTTP specification. There can be used Websockets etc. in real use cases.

## Configuration and Running

At first you should deploy PostgreSQL database (or any other) and fill connection configuration in [database.yml](https://github.com/kyberpunk/smartplug-api/blob/master/config/database.yml). Next you should have access to IoT Hub service and set its connection string in [database.yml](https://github.com/kyberpunk/smartplug-api/blob/master/config/iothub.yml) (service role at least).

Next you need to generate RSA key for JWT authentication. You can use openssl on Linux:

`openssl genrsa -out app.rsa 2048`

`openssl rsa -in app.rsa -pubout > app.rsa.pub`

Now install gems and run the application localy listening on port 8000. 

```
bundle install
bundle exec rackup config.ru -p 8000 -s thin -o "0.0.0.0"
```

## Docker

There is also [Dockerfile](https://github.com/kyberpunk/smartplug-api/blob/master/Dockerfile) you can use for deploying docker image with appliacation anywhere.

## REST API Resources

REST API uses JSON content type for all resources. All resources require authentication. API returns 400 BadRequest HTTP status code if any handled error occurs.

### Users resource

Users resource contains information about users.

JSON:
```
{  
   "id": integer,
   "user_name": "string",
   "email": "string"
}
```

Resources:

* `GET /users/self`

Get currently signed user resource. Returns 200 with user resource.

* `POST /users`

Register new user. Returns 201 with created user resource.

Request body:
```
{
   "user_name": "string",
   "email": "string",
   "password": "string"
}
```

* `PATCH /users/self`

Update user resource properties. Returns 201 with updated user resource.

* `DELETE /users/self`

Delete currently signed user. Returns 204.

### Homes resource

## Authentication
