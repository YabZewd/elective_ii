import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/review.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/api/api.dart';

class RemoteApi {
  static Future<Map<String, dynamic>> fetchReviews(
    int page, {
    String? lotId,
    int limit = 1000,
  }) async {
    // final offset = (page - 1) * limit;
    final offset = (page - 1) * limit;
    print('in fetch reviews');
    final token = await jwtToken;
    final baseUri = Uri.parse(baseUrlJani);
    final url = baseUri.replace(
      path: '/v1/reviews',
      queryParameters: {
        'lotId': '$lotId',
        'offset': '$offset',
        'limit': '$limit',
      },
    );
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        'x-client-type': 'customer',
      },
    );
    print('response body \\${response.body}');
    final Map<String, dynamic> decoded = jsonDecode(response.body);
    final int? averageRating = decoded['averageRating'];
    final List reviews = decoded['reviews'];
    print('decoded \\${decoded}');
    print('decoded \\${decoded['reviews']}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded['reviews'] is List) {
        print('decoded is list');
        return {
          "rating": averageRating,
          "reviews": reviews.map((review) => Review.fromJson(review)).toList()
        };
      } else {
        print('Unexpected response type: \\${decoded.runtimeType}');
        throw Exception('Unexpected response type when fetching reviews');
      }
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  static Future<void> submitReview({
    required String lotId,
    required int rating,
    required String comment,
  }) async {
    final token = await jwtToken;
    final url = Uri.parse('$baseUrlJani/v1/reviews');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-client-type': 'customer',
      },
      body: jsonEncode({
        "lotId": lotId,
        "rating": rating,
        "comment": comment,
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to submit review');
    }
  }
}
