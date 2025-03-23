import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../utils/logging.dart';

class TavusOnboardingService {
  static const String _baseUrl = 'https://tavusapi.com/v2';
  static const String _apiKey = '09a327468ee24eaa85c061e10d9ce293'; // Same API key as main service
  static const String _replicaId = 'r0c4d42ecf0b'; // Same replica ID as main service
  static const String _personaId = 'pe8b90193176'; // Same persona ID as main service
  final _logger = Logger('TavusOnboardingService');

  Future<ConversationResponse> createOnboardingCall() async {
    try {
      _logger.info('Creating new Tavus onboarding assessment call');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/conversations'),
        headers: {
          'x-api-key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'replica_id': _replicaId,
          'persona_id': _personaId,
          'conversation_name': 'Initial Health Assessment',
          'custom_greeting': "Hello! I'm here to conduct your initial health assessment. Let's get started!",
          'properties': {
            'max_call_duration': 3600,
            'participant_left_timeout': 60,
            'participant_absent_timeout': 300,
            'enable_recording': true,
            'enable_transcription': true,
            'apply_greenscreen': true,
            'language': 'english',
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final conversationUrl = data['conversation_url'];
        final conversationId = data['conversation_id'] ?? _extractConversationId(conversationUrl);
        _logger.info('Successfully created Tavus onboarding call: $conversationUrl');
        return ConversationResponse(
          conversationId: conversationId,
          conversationUrl: conversationUrl,
        );
      } else {
        final error = 'Failed to create onboarding call: ${response.statusCode} - ${response.body}';
        _logger.severe(error);
        throw Exception(error);
      }
    } catch (e) {
      _logger.severe('Error creating onboarding call: $e');
      throw Exception('Failed to create onboarding call: $e');
    }
  }

  String _extractConversationId(String url) {
    return url.split('/').last;
  }

  Future<Map<String, dynamic>> getVideoCallStatus(String callId) async {
    try {
      _logger.info('Checking onboarding call status: $callId');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/conversations/$callId'),
        headers: {
          'x-api-key': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _logger.info('Successfully retrieved call status for: $callId');
        return data;
      } else {
        final error = 'Failed to get call status: ${response.statusCode} - ${response.body}';
        _logger.severe(error);
        throw Exception(error);
      }
    } catch (e) {
      _logger.severe('Error getting call status: $e');
      throw Exception('Failed to get call status: $e');
    }
  }

  Future<void> endCall(String callId) async {
    try {
      _logger.info('Ending onboarding call: $callId');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/conversations/$callId/end'),
        headers: {
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        _logger.severe('Failed to end onboarding call: ${error['message']}');
        throw TavusException('Failed to end onboarding call: ${error['message']}');
      }

      _logger.info('Successfully ended onboarding call: $callId');
    } catch (e) {
      _logger.severe('Error ending onboarding call: $e');
      throw TavusException('Error ending onboarding call: $e');
    }
  }
}

class ConversationResponse {
  final String conversationId;
  final String conversationUrl;

  ConversationResponse({
    required this.conversationId,
    required this.conversationUrl,
  });
}

class TavusException implements Exception {
  final String message;
  TavusException(this.message);

  @override
  String toString() => message;
} 
