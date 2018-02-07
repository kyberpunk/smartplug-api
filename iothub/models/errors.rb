# Base error for Iot Hub client
class IotHubError < StandardError

end

# Authorization failed
class UnauthorizedError < IotHubError

end

# Device does not exist or not connected
class DeviceNotFoundError < IotHubError

end

# Action was refused by device
class RefusedByDeviceError < IotHubError

end

# Communication with the device timed out
class DeviceTimeoutError < IotHubError

end