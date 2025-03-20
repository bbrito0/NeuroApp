import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../utils/logging.dart';

class TavusService {
  static const String _baseUrl = 'https://tavusapi.com/v2';
  static const String _apiKey = 'c0e827e4927342678a58e7d0e3cb979b'; // Replace with your API key
  static const String _replicaId = 'r14ea4b254d5'; // Replace with your replica ID
  static const String _personaId = 'p07fb322da79'; // Replace with your persona ID
  final _logger = Logger('TavusService');

  Future<ConversationResponse> createConversation({
    String? conversationName,
    String? conversationalContext,
    String? customGreeting,
    Map<String, dynamic>? properties,
  }) async {
    try {
      _logger.info('Creating new Tavus conversation');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/conversations'),
        headers: {
          'x-api-key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'replica_id': _replicaId,
          'persona_id': _personaId,
          'conversation_name': conversationName ?? 'Tavus Conversation',
          'conversational_context': conversationalContext,
          'custom_greeting': "Hello! It's nice to see you again! Ready to start your Daily Check-in?",
          'properties': properties ?? {
            'max_call_duration': 3600,
            'participant_left_timeout': 60,
            'participant_absent_timeout': 300,
            'enable_recording': false, // Disabled for local development
            'enable_transcription': false, // Disabled for local development
            'apply_greenscreen': true,
            'language': 'english',
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final conversationUrl = data['conversation_url'];
        final conversationId = data['conversation_id'] ?? _extractConversationId(conversationUrl);
        _logger.info('Successfully created Tavus conversation: $conversationUrl');
        return ConversationResponse(
          conversationId: conversationId,
          conversationUrl: conversationUrl,
        );
      } else {
        final error = 'Failed to create conversation: ${response.statusCode} - ${response.body}';
        _logger.severe(error);
        throw Exception(error);
      }
    } catch (e) {
      _logger.severe('Error creating conversation: $e');
      throw Exception('Failed to create conversation: $e');
    }
  }

  String _extractConversationId(String url) {
    // Extract conversation ID from URL (e.g., https://tavus.daily.co/abc123 -> abc123)
    return url.split('/').last;
  }

  Future<List<String>> listActiveConversations() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/conversations'),
        headers: {
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['conversations'] ?? []);
      }
      return [];
    } catch (e) {
      _logger.warning('Error listing conversations: $e');
      return [];
    }
  }

  Future<void> endAllActiveConversations() async {
    try {
      final activeConversations = await listActiveConversations();
      for (final conversationId in activeConversations) {
        await endConversation(conversationId);
      }
    } catch (e) {
      _logger.warning('Error ending active conversations: $e');
    }
  }

  /// Ends an active conversation
  Future<void> endConversation(String conversationId) async {
    try {
      _logger.info('Ending conversation: $conversationId');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/conversations/$conversationId/end'),
        headers: {
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        _logger.severe('Failed to end conversation: ${error['message']}');
        throw TavusException('Failed to end conversation: ${error['message']}');
      }

      _logger.info('Successfully ended conversation: $conversationId');
    } catch (e) {
      _logger.severe('Error ending conversation: $e');
      throw TavusException('Error ending conversation: $e');
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