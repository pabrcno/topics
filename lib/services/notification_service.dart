import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:topics/domain/core/enums.dart';

import 'package:topics/services/permission_service.dart';

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  log('onActionReceivedMethod: ${receivedAction.buttonKeyInput}');
  final SendPort? port =
      IsolateNameServer.lookupPortByName(NotificationService.isolateName);
  port?.send(receivedAction.buttonKeyInput);
}

typedef NotificationCallback = Future<void> Function(String input);

class NotificationService {
  ReceivedNotification? _receivedNotification;
  ReceivedAction? _receivedAction;
  final NotificationCallback onMessageReply;
  static const String isolateName = 'isolate';
  final ReceivePort _port = ReceivePort();

  NotificationService({required this.onMessageReply}) {
    IsolateNameServer.registerPortWithName(_port.sendPort, isolateName);
    _port.listen((dynamic data) {
      String input = data as String;
      onMessageReply(input);
    });
  }

  ReceivedNotification? get receivedNotification => _receivedNotification;
  ReceivedAction? get receivedAction => _receivedAction;

  Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    _receivedNotification = receivedNotification;
  }

  Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    _receivedNotification = receivedNotification;
  }

  Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    _receivedAction = receivedAction;
  }

  Future<void> createChatNotification(String body, EMessageRole role) async {
    if (await permissionServiceProvider.requestNotificationsPermission()) {
      AwesomeNotifications()
          .setListeners(onActionReceivedMethod: onActionReceivedMethod);
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: -1, // -1 is replaced by a random number
              channelKey: 'topics_chat_channel',
              body: role == EMessageRole.assistant ? body : null,
              bigPicture: role == EMessageRole.imageAssistant ? body : null,
              largeIcon: 'asset://assets/images/topics_dark_removebg.png',

              //'asset://assets/images/balloons-in-sky.jpg',
              notificationLayout: NotificationLayout.BigPicture,
              payload: {'notificationId': '1234567890'}),
          actionButtons: [
            NotificationActionButton(
                key: 'Text Reply',
                label: 'Reply Message',
                requireInputText: true,
                actionType: ActionType.SilentAction),
            NotificationActionButton(
                key: 'Image Generation',
                label: 'Generate Image',
                requireInputText: true,
                actionType: ActionType.SilentAction),
            NotificationActionButton(
                key: 'DISMISS',
                label: 'Dismiss',
                actionType: ActionType.DismissAction,
                isDangerousOption: true)
          ]);
    }
  }
}
