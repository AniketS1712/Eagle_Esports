import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Handles unsigned image uploads to Cloudinary.
///
/// IMPORTANT: replace the two placeholders below with your actual
/// Cloudinary cloud name and unsigned upload preset name. Never put
/// your Cloudinary API *secret* here — unsigned presets only need
/// the cloud name + preset name, both of which are safe to ship in
/// a mobile client.
class CloudinaryService {
  static const String _cloudName = 'daez9rfrd';
  static const String _uploadPreset = 'Eagle_Esports';

  static Uri get _uploadUrl =>
      Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');

  /// Uploads [file] and returns the resulting secure HTTPS URL.
  /// Throws an [Exception] with the Cloudinary error message on failure.
  Future<String> uploadImage(File file) async {
    final request = http.MultipartRequest('POST', _uploadUrl)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final message = (body['error'] as Map?)?['message'] ?? 'Upload failed';
      throw Exception('Cloudinary upload failed: $message');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['secure_url'] as String;
  }
}
