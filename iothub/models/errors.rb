class IotHubError < StandardError

end

class UnauthorizedError < IotHubError

end

class DeviceNotFoundError < IotHubError

end

class RefusedByDeviceError < IotHubError

end

class DeviceTimeoutError < IotHubError

end