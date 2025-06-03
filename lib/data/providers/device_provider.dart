import 'package:flutter/material.dart';
import '../models/device_model.dart';
import '../repositories/device_repository.dart';

class DeviceProvider with ChangeNotifier {
  final DeviceRepository _repository = DeviceRepository();
  List<Device> _devices = [];
  bool _isLoading = false;

  DeviceProvider() {
    loadDevices();
  }

  List<Device> get devices => _devices;
  bool get isLoading => _isLoading;

  Future<void> loadDevices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _devices = await _repository.getAllDevices();
    } catch (e) {
      debugPrint('Erro ao carregar dispositivos: $e');
      _devices = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addDevice(Device device) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.addDevice(device);
      await loadDevices();
    } catch (e) {
      debugPrint('Erro ao adicionar dispositivo: $e');
      rethrow;
    }
  }

  Future<void> updateDevice(Device device) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateDevice(device);
      await loadDevices();
    } catch (e) {
      debugPrint('Erro ao atualizar dispositivo: $e');
      rethrow;
    }
  }

  Future<void> toggleDeviceStatus(String deviceId) async {
    try {
      final device = _devices.firstWhere((d) => d.id == deviceId);
      final updatedDevice = device.copyWith(isOn: !device.isOn);
      await updateDevice(updatedDevice);
    } catch (e) {
      debugPrint('Erro ao alterar status do dispositivo: $e');
      rethrow;
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteDevice(deviceId);
      await loadDevices();
    } catch (e) {
      debugPrint('Erro ao deletar dispositivo: $e');
      rethrow;
    }
  }
}
