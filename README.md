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

REST API uses JSON content type for all resources. All resources require authentication. API returns 400 BadRequest HTTP status code if any handled error occurs. API returns 401 Unauthorized status code when user not authorized.

### Users resource

Users resource contains information about users.

#### JSON:
```
{  
   "id": integer,
   "user_name": "string",
   "email": "string"
}
```

#### Resources:

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

Home resource serve as container for outlets and appliances used in one location.

#### JSON:
```
{  
   "id": integer,
   "name": "string",
   "apartment": "string",
   "city": "string",
   "street": "string",
   "zip_code": "string",
   "country_code": "string",
   "user_id": integer
}
```

#### Resources:

* `GET /homes`

Get all user homes. Returns 200 with home resources.

* `GET /homes/:id`

Get home resource by ID. Returns 200 with home resource.

* `POST /homes`

Create new home resource. Returns 201 with created home resource.

* `PUT /homes/:id`

Update home resource. Returns 201 with updated home resource.

* `DELETE /homes/:id`

Delete home resource. Returns 204.

* `GET /homes/:id/appliances`

Get appliance resources related to the home. Returns 200 with appliance resources.

* `GET /homes/:id/outlets`

Get outlet resources related to the home. Returns 200 with outlet resources.

### Appliances resource

Appliance resource represents the appliance which can be plugged into outlet (SmartPlug device).

#### JSON:
```
{  
   "id": integer,
   "name": "string",
   "appliance_type": "string",
   "home_id": integer
}
```

#### Resources:

* `GET /appliances`

Get all user appliances. Returns 200 with appliance resources.

* `GET /appliances/:id`

Get appliance resource by ID. Returns 200 with appliance resource.

* `POST /appliances`

Create new appliance resource. Returns 201 with created appliance resource.

* `PUT /appliances/:id`

Update appliance resource. Returns 201 with updated appliance resource.

* `DELETE /appliances/:id`

Delete appliance resource. Returns 204.

* `GET /appliances/:id/outlet`

Get outlet resource related to the appliance if any. Returns 200 with outlet resource.

### Oulets resource

Outlet resource represents the SmartPlug device abstraction for bussines logic.

#### JSON:
```
{  
   "id": integer,
   "name": "string",
   "device_id": "string",
   "home_id": integer,
   "appliance_id": integer
}
```

#### Resources:

* `GET /outlets`

Get all user outlets. Returns 200 with outlet resources.

* `GET /outlets/:id`

Get outlet resource by ID. Returns 200 with outlet resource.

* `POST /outlets`

Create new outlet resource. Returns 201 with created outlet resource. Device with provided device ID must be present in the IoT Hub service registry.

* `PUT /outlets/:id`

Update outlet resource. Returns 201 with updated outlet resource.

* `DELETE /outlets/:id`

Delete outlet resource. Returns 204.

* `GET /outlets/:id/appliance`

Get appliance resource related to the outlet if any. Returns 200 with appliance resource.

### SmartPlugs resource

SmarPlug resource contains harware related information about the device.

#### JSON:
```
{  
   "device_id": "string",
   "actual_firmware_version": "string",
   "firmware_status": "Ok|Running|Failed",
   "firmware_status_updated_time": "time",
   "local_network_ssid": "string",
   "local_network_ip": "string",
   "is_switched_on": bool,
   "is_switched_on_updated_time": "time",
   "connection_state": "Disconnected|Connected",
   "connection_state_updated_time": "time"
}
```

#### Resources:

* `GET /smarplugs/:outlet_id`

Get SmartPlug resource related to the outlet. Returns 200 with SmartPlug resource.

* `POST /smarplugs/:outlet_id/switch?value=bool`

Switch the device relay on (true) or off (false). Returns 204.

### Direct data resource

Direct data resource contains latest measurement data.

#### JSON:
```
{  
   "period": long,
   "timestamp": long,
   "active_power": float,
   "rms_voltage": float,
   "rms_current": float
}
```

#### Resources:

* `GET /smarplugs/:outlet_id/directdata`

Get latest direct data. Returns 200 with direct data resource.

* `POST /smarplugs/:outlet_id/directdata/start`

Force SmartPlug device to start sending direct data. Returns status 204.

## Authentication

SmartPlug API uses the simple implementation of JWT authentication tokens. More information about JWT you can found here: https://jwt.io/.

Authentication implementation is base on Nick Dufresne sample project: https://github.com/nickdufresne/jwt-sinatra-example/blob/master/README.md.

* `POST /users/login`

Login user with given credentials. Returns 200 with JWT token in the body.

Request body:
```
{
   "user_name": "string",
   "password": "string"
}
```

Response body:
```
{
   "token": "base64 string",
   "expiration": "time"
}
```

Application requires JWT token in `Authorization` HTTP header in format:

`Authorization: Bearer <JWT token base64 string>`
