require_relative 'iothub/client'

connection_string = 'HostName=hexadehub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=BRTQ//t2McYeitukV0H9alzd2SPB3lmJ9MRijF3J9hc='
options = IotHubOptions.new(connection_string)
manager = DeviceManager.new(options)
devices = manager.get_devices
p(devices)
reg_statistics = manager.registry_statistics
p(reg_statistics)
ser_statistics = manager.service_statistics
p(ser_statistics)
device = manager.get_device('POSTMAN111111111')
p(device)
device.status = :disabled
device = manager.update_device(device)
p(device)
twin_manager = TwinManager.new(options)
twin = twin_manager.get_twin('POSTMAN111111111')
p(twin)
p(twin.properties.desired.version)
twin.properties.desired[:latestFirmwareVersion] = 'test'
twin = twin_manager.update_twin(twin)
p(twin.properties.desired[:latestFirmwareVersion])



