# SmartPlug API

This project was developed for course PV249 teached on [Faculty of Informatics - Masaryk University](https://www.fi.muni.cz/index.html.en)

This repository contains API implementation for controlling Hexade SmartPlug devices and some sample home management logic. Entire application is written in Ruby language. For REST API implementation is used [Sinatra](http://sinatrarb.com/) framework.

**This is only sample application and does not support all SmartPlug functionality. Application would not be supported in the future**

## Device

Device is base on low-cost [ESP-32 SoC](https://www.espressif.com/en/products/hardware/esp32/overview). The chip integrates WiFi and Bluetooth radio. Device contains accurate measuring integrated circuit and the relay for power switching.

You can find sample web presentation with additional information on: https://www.smartplug.cz/.

## Infrastrucutre

For communication and devices control is used the [Azure IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/) service which is part of the [Azure IoT Solution](https://azure.microsoft.com/cs-cz/services/iot-hub/). For more information read the docs.

## Modules



## Configuration and Running

## Docker

## REST API Resources
