import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/device_model.dart';
import '../../data/models/residence_model.dart';

class ApiService {
  static const String baseUrl = 'https://smartsync-9twk.onrender.com';

  Future<Device> addDevice(Device device) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Dispositivo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(device.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Device.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Erro ao adicionar dispositivo: \\${response.statusCode}');
    }
  }

  Future<dynamic> addResidencia(Map<String, dynamic> residencia) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Residencia'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(residencia),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao adicionar residência: \\${response.statusCode}');
    }
  }

  Future<dynamic> addComodo(Map<String, dynamic> comodo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Comodo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(comodo),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao adicionar cômodo: \\${response.statusCode}');
    }
  }

  Future<void> criarUsuario(Map<String, dynamic> usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Usuario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao criar usuário: \\${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>?> buscarUsuarioPorId(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Usuario/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> buscarUsuarioPorNomeEmail(
      String nome, String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Usuario?nome=$nome&email=$email'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        // Filtra manualmente pelo nome e email exatos (case-insensitive e trim)
        for (final usuario in data) {
          if (usuario is Map<String, dynamic>) {
            final nomeApi =
                (usuario['nome'] ?? '').toString().trim().toLowerCase();
            final emailApi =
                (usuario['email'] ?? '').toString().trim().toLowerCase();
            if (nomeApi == nome.trim().toLowerCase() &&
                emailApi == email.trim().toLowerCase()) {
              return usuario;
            }
          }
        }
        return null;
      } else if (data is Map<String, dynamic>) {
        return data;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> listarResidenciasPorUsuario(
      String usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Residencia?usuarioId=$usuarioId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> listarComodosPorUsuario(
      String usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Comodo?usuarioId=$usuarioId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> listarDispositivosPorUsuario(
      String usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Dispositivo?usuarioId=$usuarioId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> listarTiposDispositivo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tipoDispositivo'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }

  Future<void> addTipoDispositivo(Map<String, dynamic> tipo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tipoDispositivo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tipo),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
          'Erro ao adicionar tipo de dispositivo: ${response.statusCode}');
    }
  }

  Future<void> addDispositivo(Map<String, dynamic> dispositivo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Dispositivo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dispositivo),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao adicionar dispositivo: ${response.statusCode}');
    }
  }

  Future<void> acionarDispositivo(String id, String acao) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Dispositivo/$id/acao?acao=$acao'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'acao': acao}),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao acionar dispositivo: ${response.statusCode}');
    }
  }

  Future<void> deletarDispositivo(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/Dispositivo/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao deletar dispositivo: ${response.statusCode}');
    }
  }
}

  Future<void> enviarAcaoComodo(String id, String acao) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Comodo/$id/acao?acao=$acao'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao enviar ação: ${response.statusCode}');
    }
  }

  Future<void> enviarAcaoResidencia(String id, String acao) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Residencia/$id/acao?acao=$acao'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao enviar ação: ${response.statusCode}');
    }
  }