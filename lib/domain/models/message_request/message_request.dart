import 'package:freezed_annotation/freezed_annotation.dart';

import '../message/message.dart';
part 'message_request.freezed.dart';
part 'message_request.g.dart';

@freezed
class MessageRequest with _$MessageRequest {
  const factory MessageRequest({
    required String userToken,
    required List<Message> messages,
    required double temperature,
  }) = _MessageRequest;

  factory MessageRequest.fromJson(Map<String, dynamic> json) =>
      _$MessageRequestFromJson(json);
}
