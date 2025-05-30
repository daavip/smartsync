import '../models/device_model.dart';

class DeviceRepository {
  final List<Device> _devices = [];

  Future<List<Device>> getAllDevices() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    return _devices;
  }

  Future<Device> getDeviceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _devices.firstWhere(
      (device) => device.id == id,
      orElse: () => throw Exception('Device with id $id not found'),
    );
  }

  Future<void> addDevice(Device device) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _devices.add(device);
  }

  Future<void> updateDevice(Device updatedDevice) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _devices.indexWhere((d) => d.id == updatedDevice.id);
    if (index != -1) {
      _devices[index] = updatedDevice;
    }
  }

  Future<void> deleteDevice(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _devices.removeWhere((device) => device.id == id);
  }
}