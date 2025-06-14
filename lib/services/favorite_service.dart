import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/api/api.dart';
import 'package:mobile/models/lots.dart';
import 'package:mobile/utils/constants.dart';

Future<bool> toggleFavoriteLot(String lotId, {required bool isFavorite}) async {
  final token = await jwtToken;
  final url = Uri.parse('$baseUrlJani/v1/lots/$lotId/favorite');
  final response = isFavorite
      ? await http.delete(url, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-client-type': 'customer',
        })
      : await http.post(url, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'x-client-type': 'customer',
        });
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return true;
  } else {
    try {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Failed to update favorite');
    } catch (_) {
      throw Exception(response.body);
    }
  }
}

Future<List<dynamic>> fetchFavorites() async {
  final token = await jwtToken;
  final url = Uri.parse('$baseUrlJani/v1/lots/favorites');
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
    'x-client-type': 'customer',
  });

  print('//////////////////////////////////');
  print(response.statusCode);
  print(response.headers);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    print('data: $data');
    print('data:///////////////////////////////////');
    final List<dynamic> returned = data['lots'].map((json) {
      print('Passing to Lots.fromJson: $json');
      return Lots.fromJson(json);
    }).toList();

    print('returned data: $returned');
    return returned;
  } else {
    // print('Exception in fetchFavorites: $e');
    // print('Stack trace: $stack');
    print('Response status: \\${response.statusCode}');
    print('Response body: \\${response.body}');
    throw Exception('Failed to load favorites: ');
  }
}

Future<bool> fetchFavoriteStatus(String lotId) async {
  final token = await jwtToken;
  final url = Uri.parse('$baseUrlJani/v1/lots/$lotId/favorite');
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
    'x-client-type': 'customer',
  });
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // API should return { isFavorite: true/false } or similar
    if (data is Map && data.containsKey('isFavorited')) {
      return data['isFavorited'];
    } else if (data is bool) {
      return data;
    } else {
      throw Exception('Unexpected response: $data');
    }
  } else {
    throw Exception('Failed to fetch favorite status: ${response.statusCode}');
  }
}
