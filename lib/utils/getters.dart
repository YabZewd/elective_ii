import 'package:flutter/material.dart';
import 'package:mobile/api/api.dart';

ImageProvider getLotImageProvider(String? imageName) {
  final url = '$baseUrlJani/uploads/lots/$imageName';
  if (imageName == null) {
    return const AssetImage('assets/images/placeholder_image.png');
  }
  return NetworkImage(
    url,
  );
}
