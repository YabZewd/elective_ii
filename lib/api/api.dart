const String baseUrlJani = 'http://10.0.2.2:5000'; // For emulator testing
const String baseUrlMob =
    'http://192.168.1.X:5000'; // For physical device testing

final loginUrl = Uri.parse('$baseUrlJani/v1/customer/auth/login');
final signupUrl = Uri.parse('$baseUrlJani/v1/customer/auth/signup');
final parkingLotsUrl = Uri.parse('$baseUrlJani/v1/lots/nearby');
final historyUrl = Uri.parse('$baseUrlJani/v1/lots/nearby');
final imageUrl = Uri.parse('$baseUrlJani/v1/uploads/lots');
