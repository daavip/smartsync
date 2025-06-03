import '../models/device_model.dart';
import '../../core/services/storage_service.dart';

class DeviceRepository {
  static const String _devicesKey = 'devices';
  List<Device> _devices = [];
  late StorageService _storage;
  bool _initialized = false;

  Future<void> _init() async {
    if (!_initialized) {
      _storage = await StorageService.getInstance();
      await _loadDevicesFromStorage();
      _initialized = true;
    }
  }

  Future<void> _loadDevicesFromStorage() async {
    final devicesData = _storage.getObjectList(_devicesKey);
    if (devicesData != null) {
      _devices = devicesData.map((json) => Device.fromJson(json)).toList();
    }
  }

  Future<void> _saveDevicesToStorage() async {
    final devicesData = _devices.map((device) => device.toJson()).toList();
    await _storage.saveObjectList(_devicesKey, devicesData);
  }

  Future<List<Device>> getAllDevices() async {
    await _init();
    return _devices;
  }

  Future<Device> getDeviceById(String id) async {
    await _init();
    return _devices.firstWhere(
      (device) => device.id == id,
      orElse: () => throw Exception('Device with id $id not found'),
    );
  }

  Future<Device> addDevice(Device device) async {
    await _init();
    final newDevice = device.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _devices.add(newDevice);
    await _saveDevicesToStorage();
    return newDevice;
  }

  Future<void> updateDevice(Device updatedDevice) async {
    await _init();
    final index = _devices.indexWhere((d) => d.id == updatedDevice.id);
    if (index != -1) {
      _devices[index] = updatedDevice;
      await _saveDevicesToStorage();
    }
  }

  Future<void> deleteDevice(String id) async {
    await _init();
    _devices.removeWhere((device) => device.id == id);
    await _saveDevicesToStorage();
  }
}
