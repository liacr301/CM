import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class SwitchBotService {
  final String token;
  final String secret;

  SwitchBotService({required this.token, required this.secret});

  String generateSignature(String token, String secret, String t, String nonce) {
    final stringToSign = '$token$t$nonce';
    final key = utf8.encode(secret);
    final bytes = utf8.encode(stringToSign);

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    return base64.encode(digest.bytes);
  }

  Future<Map<String, dynamic>> fetchSensorData(String deviceId) async {
    final t = DateTime.now().millisecondsSinceEpoch.toString();
    final nonce = Uuid().v4();
    final sign = generateSignature(token, secret, t, nonce);

    final headers = {
      'Authorization': token,
      't': t,
      'sign': sign,
      'nonce': nonce,
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('https://api.switch-bot.com/v1.0/devices/$deviceId/status'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['body'];
    } else {
      throw Exception('Erro ao buscar dados do sensor: ${response.statusCode}');
    }
  }
}
