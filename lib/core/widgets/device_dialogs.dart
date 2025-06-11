import 'package:flutter/material.dart';
import 'package:smartsync/core/services/api_service.dart';
import '../../data/models/device_model.dart';
import '../../data/models/device_settings.dart';
import '../constants/app_colors.dart';

class DeviceDialogs {
  static Future<void> showLightDialog(
    BuildContext context,
    Device device,
    Function(Device) onUpdate,
  ) async {
    final settings = device.settings as LightSettings;
    double brightness = settings.brightness;
    Color color = settings.color;
    bool isOn = device.isOn;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(device.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(isOn ? 'Ligada' : 'Desligada'),
                value: isOn,
                onChanged: (value) async {
                                try {
                                  final api = ApiService();
                                  await api.enviarAcaoDispositivo(
                                    device.id,
                                    value ? 'Ligar' : 'Desligar',
                                  );
                                  setState(() {
                                    device.isOn = value;
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Erro ao ${value ? 'ligar' : 'desligar'} o dispositivo: $e',
                                      ),
                                    ),
                                  );
                                }
                }
              ),
              const Divider(),
              const Text('Brilho'),
              Slider(
                value: brightness,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  setState(() => brightness = value);
                  onUpdate(device.copyWith(
                    settings: LightSettings(
                      brightness: brightness,
                      color: color,
                    ),
                  ));
                },
              ),
              const SizedBox(height: 16),
              const Text('Cor'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Colors.white,
                  Colors.yellow,
                  Colors.orange,
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.purple,
                ]
                    .map((c) => InkWell(
                          onTap: () {
                            setState(() => color = c);
                            onUpdate(device.copyWith(
                              settings: LightSettings(
                                brightness: brightness,
                                color: color,
                              ),
                            ));
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: color == c
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showAirConditionerDialog(
    BuildContext context,
    Device device,
    Function(Device) onUpdate,
  ) async {
    final settings = device.settings as AirConditionerSettings;
    double temperature = settings.temperature;
    bool isAuto = settings.isAuto;
    String mode = settings.mode;
    bool isOn = device.isOn;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(device.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(isOn ? 'Ligado' : 'Desligado'),
                value: isOn,
                onChanged: (value) {
                  setState(() => isOn = value);
                  onUpdate(device.copyWith(isOn: isOn));
                },
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        temperature = (temperature - 0.5).clamp(16, 30);
                      });
                      onUpdate(device.copyWith(
                        settings: AirConditionerSettings(
                          temperature: temperature,
                          isAuto: isAuto,
                          mode: mode,
                        ),
                      ));
                    },
                  ),
                  Text(
                    '${temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        temperature = (temperature + 0.5).clamp(16, 30);
                      });
                      onUpdate(device.copyWith(
                        settings: AirConditionerSettings(
                          temperature: temperature,
                          isAuto: isAuto,
                          mode: mode,
                        ),
                      ));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Modo Automático'),
                value: isAuto,
                onChanged: (value) {
                  setState(() => isAuto = value);
                  onUpdate(device.copyWith(
                    settings: AirConditionerSettings(
                      temperature: temperature,
                      isAuto: isAuto,
                      mode: mode,
                    ),
                  ));
                },
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'cool',
                    icon: Icon(Icons.ac_unit),
                    label: Text('Resfriar'),
                  ),
                  ButtonSegment(
                    value: 'heat',
                    icon: Icon(Icons.whatshot),
                    label: Text('Aquecer'),
                  ),
                  ButtonSegment(
                    value: 'fan',
                    icon: Icon(Icons.wind_power),
                    label: Text('Ventilar'),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (Set<String> selection) {
                  setState(() => mode = selection.first);
                  onUpdate(device.copyWith(
                    settings: AirConditionerSettings(
                      temperature: temperature,
                      isAuto: isAuto,
                      mode: mode,
                    ),
                  ));
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showTVDialog(
    BuildContext context,
    Device device,
    Function(Device) onUpdate,
  ) async {
    final settings = device.settings as TVSettings;
    int volume = settings.volume;
    String input = settings.input;
    bool isMuted = settings.isMuted;
    String channel = settings.channel;
    bool isOn = device.isOn;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(device.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(isOn ? 'Ligada' : 'Desligada'),
                value: isOn,
                onChanged: (value) {
                  setState(() => isOn = value);
                  onUpdate(device.copyWith(isOn: isOn));
                },
              ),
              const Divider(),
              Row(
                children: [
                  IconButton(
                    icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                    onPressed: () {
                      setState(() => isMuted = !isMuted);
                      onUpdate(device.copyWith(
                        settings: TVSettings(
                          volume: volume,
                          input: input,
                          isMuted: isMuted,
                          channel: channel,
                        ),
                      ));
                    },
                  ),
                  Expanded(
                    child: Slider(
                      value: volume.toDouble(),
                      min: 0,
                      max: 100,
                      onChanged: (value) {
                        setState(() => volume = value.round());
                        onUpdate(device.copyWith(
                          settings: TVSettings(
                            volume: volume,
                            input: input,
                            isMuted: isMuted,
                            channel: channel,
                          ),
                        ));
                      },
                    ),
                  ),
                  Text('$volume'),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: input,
                decoration: const InputDecoration(
                  labelText: 'Entrada',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'HDMI 1',
                  'HDMI 2',
                  'TV Digital',
                  'Netflix',
                  'YouTube',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value.toLowerCase().replaceAll(' ', ''),
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => input = newValue);
                    onUpdate(device.copyWith(
                      settings: TVSettings(
                        volume: volume,
                        input: input,
                        isMuted: isMuted,
                        channel: channel,
                      ),
                    ));
                  }
                },
              ),
              if (input == 'tvdigital') ...[
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Canal',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: channel),
                  onChanged: (value) {
                    setState(() => channel = value);
                    onUpdate(device.copyWith(
                      settings: TVSettings(
                        volume: volume,
                        input: input,
                        isMuted: isMuted,
                        channel: channel,
                      ),
                    ));
                  },
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showSpeakerDialog(
    BuildContext context,
    Device device,
    Function(Device) onUpdate,
  ) async {
    final settings = device.settings as SpeakerSettings;
    int volume = settings.volume;
    bool isMuted = settings.isMuted;
    double bass = settings.bass;
    double treble = settings.treble;
    String input = settings.input;
    bool isOn = device.isOn;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(device.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(isOn ? 'Ligado' : 'Desligado'),
                value: isOn,
                onChanged: (value) async {
                  try {
                    final api = ApiService();
                    await api.enviarAcaoDispositivo(
                      device.id,
                      value ? 'Ligar' : 'Desligar',
                    );
                    setState(() {
                      device.isOn = value;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Erro ao ${value ? 'ligar' : 'desligar'} o dispositivo: $e',
                        ),
                      ),
                    );
                  }
                }
              ),
              const Divider(),
              Row(
                children: [
                  IconButton(
                    icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                    onPressed: () {
                      setState(() => isMuted = !isMuted);
                      onUpdate(device.copyWith(
                        settings: SpeakerSettings(
                          volume: volume,
                          isMuted: isMuted,
                          bass: bass,
                          treble: treble,
                          input: input,
                        ),
                      ));
                    },
                  ),
                  Expanded(
                    child: Slider(
                      value: volume.toDouble(),
                      min: 0,
                      max: 100,
                      onChanged: (value) {
                        setState(() => volume = value.round());
                        onUpdate(device.copyWith(
                          settings: SpeakerSettings(
                            volume: volume,
                            isMuted: isMuted,
                            bass: bass,
                            treble: treble,
                            input: input,
                          ),
                        ));
                      },
                    ),
                  ),
                  Text('$volume'),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Graves'),
              Slider(
                value: bass,
                min: -10,
                max: 10,
                onChanged: (value) {
                  setState(() => bass = value);
                  onUpdate(device.copyWith(
                    settings: SpeakerSettings(
                      volume: volume,
                      isMuted: isMuted,
                      bass: bass,
                      treble: treble,
                      input: input,
                    ),
                  ));
                },
              ),
              const SizedBox(height: 8),
              const Text('Agudos'),
              Slider(
                value: treble,
                min: -10,
                max: 10,
                onChanged: (value) {
                  setState(() => treble = value);
                  onUpdate(device.copyWith(
                    settings: SpeakerSettings(
                      volume: volume,
                      isMuted: isMuted,
                      bass: bass,
                      treble: treble,
                      input: input,
                    ),
                  ));
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: input,
                decoration: const InputDecoration(
                  labelText: 'Entrada',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Bluetooth',
                  'Auxiliar',
                  'Óptico',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value.toLowerCase(),
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => input = newValue);
                    onUpdate(device.copyWith(
                      settings: SpeakerSettings(
                        volume: volume,
                        isMuted: isMuted,
                        bass: bass,
                        treble: treble,
                        input: input,
                      ),
                    ));
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }
}
