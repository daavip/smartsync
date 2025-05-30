import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../repositories/device_repository.dart';

class DeviceProvider with ChangeNotifier {
  final DeviceRepository _repository = DeviceRepository();
  List<Device> _devices = [];
  bool _isLoading = false;

  List<Device> get devices => _devices;
  bool get isLoading => _isLoading;

  Future<void> loadDevices() async {
    _isLoading = true;
    notifyListeners();

    _devices = await _repository.getAllDevices();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addDevice(Device device) async {
    _isLoading = true;
    notifyListeners();

    await _repository.addDevice(device);
    await loadDevices();
  }

  Future<void> updateDevice(Device device) async {
    _isLoading = true;
    notifyListeners();

    await _repository.updateDevice(device);
    await loadDevices();
  }

  Future<void> toggleDeviceStatus(String deviceId) async {
    final device = _devices.firstWhere((d) => d.id == deviceId);
    final updatedDevice = device.copyWith(isOn: !device.isOn);
    await updateDevice(updatedDevice);
  }

  Future<void> deleteDevice(String deviceId) async {
    _isLoading = true;
    notifyListeners();

    await _repository.deleteDevice(deviceId);
    await loadDevices();
  }
}