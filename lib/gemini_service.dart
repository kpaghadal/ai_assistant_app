import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class GeminiService {
  GeminiService({String? apiKey, http.Client? client})
      : _client = client ?? http.Client(),
        _apiKey = _resolveApiKey(apiKey);

  static const String _defaultModel = 'gemini-2.5-flash';
  static const String _missingKeyMessage =
      'Error: Gemini story service is not configured. Provide GEMINI_API_KEY via --dart-define or pass an apiKey to GeminiService.';
  static const String _hardcodedApiKey =
      'AIzaSyA73xlQ4e1kve_VJNiPK-M81AaYIW7e-oY';
  final String _apiKey;
  final http.Client _client;

  bool get isConfigured => _apiKey.isNotEmpty;

  Future<String> getResponse(String prompt) async {
    try {
      if (!isConfigured) {
        return _missingKeyMessage;
      }

      final sanitizedPrompt = prompt.trim();
      if (sanitizedPrompt.isEmpty) {
        return 'Error: Prompt cannot be empty.';
      }

      final payload = <String, dynamic>{
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': sanitizedPrompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topP': 0.95,
          'topK': 40,
          'maxOutputTokens': 512,
        },
      };

      final responseJson = await _postGenerateContent(payload);
      return _extractText(responseJson);
    } catch (e, stack) {
      log('Gemini text generation failed', error: e, stackTrace: stack);
      return 'Error: Unable to contact story service. Please try again.';
    }
  }

  Future<String> generateStory({
    required String prompt,
    List<int>? imageBytes,
    String? mimeType,
  }) async {
    try {
      if (!isConfigured) {
        return _missingKeyMessage;
      }

      final sanitizedPrompt = prompt.trim();
      if (sanitizedPrompt.isEmpty) {
        return 'Error: Prompt cannot be empty.';
      }

      // Build story prompt
      final storyPrompt =
          'Write a creative, engaging short story (8-12 sentences) based on this prompt: $sanitizedPrompt. Make it interesting and well-written.';

      final textParts = <Map<String, dynamic>>[
        {'text': storyPrompt},
      ];

      // Add image if provided
      if (imageBytes != null && imageBytes.isNotEmpty) {
        final resolvedMime = mimeType ??
            lookupMimeType('', headerBytes: imageBytes) ??
            'image/jpeg';
        textParts.add({
          'inlineData': {
            'mimeType': resolvedMime,
            'data': base64Encode(imageBytes),
          },
        });
      }

      final payload = <String, dynamic>{
        'contents': [
          {
            'role': 'user',
            'parts': textParts,
          },
        ],
        'generationConfig': {
          'temperature': 0.85,
          'topP': 0.9,
          'topK': 40,
          'maxOutputTokens': 1024,
        },
      };

      log('Sending story generation request with prompt: $sanitizedPrompt');

      final responseJson = await _postGenerateContent(payload);

      // ✅ Safe preview (no RangeError)
      final responseStr = responseJson.toString();
      final safePreview = responseStr.length > 200
          ? responseStr.substring(0, 200)
          : responseStr;
      log('Received response: $safePreview');

      return _extractText(responseJson);
    } catch (e, stack) {
      log('Gemini story generation failed', error: e, stackTrace: stack);
      return 'Error: Unable to generate story. Please try again. Details: $e';
    }
  }

  Future<Map<String, dynamic>> _postGenerateContent(
      Map<String, dynamic> payload) async {
    if (!isConfigured) {
      return {'error': _missingKeyMessage};
    }

    final uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/models/$_defaultModel:generateContent',
      {'key': _apiKey},
    );

    try {
      log('API URL: $uri');
      log('API Key: ${_apiKey.substring(0, 10)}...');

      // ✅ Safe payload preview
      final payloadStr = jsonEncode(payload);
      final safePayload =
          payloadStr.length > 500 ? payloadStr.substring(0, 500) : payloadStr;
      log('Payload: $safePayload...');

      final response = await _client.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: payloadStr,
      );

      log('Response status: ${response.statusCode}');

      // ✅ Safe response preview
      final responseBody = response.body;
      final safeBody =
          responseBody.length > 500 ? responseBody.substring(0, 500) : responseBody;
      log('Response body: $safeBody');

      if (response.statusCode != 200) {
        log('Gemini API error: ${response.statusCode}', error: response.body);

        final decoded =
            jsonDecode(response.body) as Map<String, dynamic>? ?? {};
        final error = decoded['error'];
        if (error is Map<String, dynamic>) {
          final message = error['message'] as String? ??
              'Unexpected error from Gemini service.';
          return {'error': 'Error: $message'};
        }

        // ✅ Safe substring here too
        final shortResp = response.body.length > 200
            ? response.body.substring(0, 200)
            : response.body;
        return {
          'error':
              'Error: Gemini service responded with status ${response.statusCode}. Response: $shortResp',
        };
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      log('Decoded response keys: ${decoded.keys.toList()}');
      return decoded;
    } catch (e, stack) {
      log('Gemini HTTP request failed', error: e, stackTrace: stack);
      return {
        'error':
            'Error: Failed to reach Gemini service. Please try again. Details: $e'
      };
    }
  }

  String _extractText(Map<String, dynamic> response) {
    // Handle API errors
    final error = response['error'];
    if (error != null) {
      if (error is String && error.startsWith('Error')) {
        log('Error found in response: $error');
        return error;
      }
      if (error is Map<String, dynamic>) {
        final message = error['message'] as String?;
        if (message != null && message.trim().isNotEmpty) {
          log('Error message: $message');
          return 'Error: $message';
        }
      }
    }

    log('Extracting text from response. Response keys: ${response.keys.toList()}');

    final buffer = StringBuffer();
    final candidates = response['candidates'];
    log('Candidates type: ${candidates.runtimeType}, is List: ${candidates is List}');

    if (candidates is List && candidates.isNotEmpty) {
      log('Processing ${candidates.length} candidates');
      for (final candidate in candidates) {
        if (candidate is Map<String, dynamic>) {
          log('Candidate keys: ${candidate.keys.toList()}');
          final content = candidate['content'];
          if (content is Map<String, dynamic>) {
            log('Content keys: ${content.keys.toList()}');
            final parts = content['parts'];
            if (parts is List) {
              log('Processing ${parts.length} parts');
              for (final part in parts) {
                if (part is Map<String, dynamic>) {
                  log('Part keys: ${part.keys.toList()}');
                  final text = part['text'];
                  if (text is String && text.trim().isNotEmpty) {
                    final safeText = text.length > 100
                        ? text.substring(0, 100)
                        : text;
                    log('Found text: $safeText...');
                    buffer.write(text);
                  }
                }
              }
            }
          }
        }
      }
    }

    final extracted = buffer.toString().trim();
    log('Extracted text length: ${extracted.length}');

    if (extracted.isNotEmpty) {
      return extracted;
    }

    final promptFeedback = response['promptFeedback'];
    if (promptFeedback is Map<String, dynamic>) {
      final feedback = promptFeedback['blockReason'];
      if (feedback is String && feedback.isNotEmpty) {
        return 'Error: Request blocked ($feedback). Please adjust your prompt.';
      }
    }

    final fullResp = response.toString();
    final safeFull =
        fullResp.length > 500 ? fullResp.substring(0, 500) : fullResp;
    log('No text extracted. Full response: $safeFull');

    return 'Error: No response from Gemini. Check console logs for details.';
  }

  static String _resolveApiKey(String? override) {
    var resolved = override ?? const String.fromEnvironment('GEMINI_API_KEY');
    if (resolved.isEmpty) {
      resolved = _hardcodedApiKey;
    }
    return resolved;
  }
}




///AIzaSyBQPCWmRt9VPDT0zVVKGimqGlrkdrwClIc