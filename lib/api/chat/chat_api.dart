import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:topics/domain/api/chat/i_chat_api.dart';
import 'package:topics/domain/services/i_auth_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/models/message/message.dart';
import '../../domain/models/message_request/message_request.dart';

class ChatApi implements IChatApi {
  final IAuthService _authService;

  ChatApi(this._authService);
  @override
  Future<Stream<Message>> createChatCompletionStream(
      List<Message> messages, double temperature) async {
    final chatUrl = dotenv.env['CHAT_URL']!;

    // final uri = Uri.parse(chatUrl);
    //LOCAL 10.0.2.2:8080
    final uri = Uri.parse('ws://10.0.2.2:8080/ws');
    final channel = WebSocketChannel.connect(uri);
    String jsonMessage = json.encode(MessageRequest(
            userToken: await _authService.getUserToken() ?? '',
            messages: messages,
            temperature: temperature)
        .toJson());

    channel.sink.add(jsonMessage);

    return channel.stream.map((event) {
      final json = jsonDecode(event);
      return Message.fromJson(json);
    });
  }
}
