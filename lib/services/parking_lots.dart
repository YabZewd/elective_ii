import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/lots.dart';

import 'package:mobile/utils/constants.dart';
import 'package:mobile/api/api.dart';

Future<List<Lots>> fetchParkingLots(double latitude, double longitude,
    {String sortBy = 'distance'}) async {
  final token = await jwtToken;
  final uri = parkingLotsUrl.replace(
    queryParameters: {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'sortBy': sortBy
    },
  );
  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-client-type': 'customer',
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    final Map<String, dynamic> lotsJson = jsonDecode(response.body);

    List<dynamic> lots = lotsJson['lots'];
    print('${lotsJson['lots']}');
    if (lotsJson['lots'] == []) {
      return [];
    }

    return lots.map((json) => Lots.fromJson(json)).toList();
  } else {
    try {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Failed to get data');
    } catch (_) {
      throw Exception(response.body);
    }
  }
}
