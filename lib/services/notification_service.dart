import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:topics/domain/core/enums.dart';

import 'package:topics/services/permission_service.dart';

const CHAT_NOTIFICATION_ID = 1020;

const IMAGE_GENERATION_KEY = 'Image Generation';
const TEXT_GENERATION_KEY = 'Text Generation';

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  NotificationService.updateChatNotification(
      receivedAction.buttonKeyInput, EMessageRole.user, true);
  final SendPort? port =
      IsolateNameServer.lookupPortByName(NotificationService.isolateName);
  port?.send({
    'input': receivedAction.buttonKeyInput,
    'key': receivedAction.buttonKeyPressed,
  });
}

typedef NotificationCallback = Future<void> Function(String input);

class NotificationService {
  ReceivedNotification? _receivedNotification;
  ReceivedAction? _receivedAction;
  final NotificationCallback onMessageReply;
  final NotificationCallback onImageGeneration;

  static const String isolateName = 'isolate';
  final ReceivePort _port = ReceivePort();

  NotificationService({
    required this.onMessageReply,
    required this.onImageGeneration,
  }) {
    IsolateNameServer.registerPortWithName(_port.sendPort, isolateName);
    _port.listen((dynamic data) {
      Map<String, String> actionData = data as Map<String, String>;
      String input = actionData['input']!;
      String key = actionData['key']!;

      if (key == TEXT_GENERATION_KEY) {
        onMessageReply(input);
      } else if (key == IMAGE_GENERATION_KEY) {
        onImageGeneration(input);
      }
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
              id: CHAT_NOTIFICATION_ID, // -1 is replaced by a random number
              channelKey: 'topics_chat_channel',
              title: role == EMessageRole.user ? 'You' : 'Assistant',
              body: role != EMessageRole.imageAssistant ? body : null,
              bigPicture: role == EMessageRole.imageAssistant ? body : null,
              largeIcon: 'asset://assets/images/topics_dark_removebg.png',
              hideLargeIconOnExpand: true,

              //'asset://assets/images/balloons-in-sky.jpg',
              notificationLayout: role == EMessageRole.imageAssistant
                  ? NotificationLayout.BigPicture
                  : NotificationLayout.BigText,
              payload: {'notificationId': '$CHAT_NOTIFICATION_ID'}),
          actionButtons: [
            NotificationActionButton(
                key: TEXT_GENERATION_KEY,
                label: 'Reply Message',
                requireInputText: true,
                actionType: ActionType.SilentAction),
            NotificationActionButton(
                key: IMAGE_GENERATION_KEY,
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

  static Future<void> updateChatNotification(
      String body, EMessageRole role, bool isLoading) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: CHAT_NOTIFICATION_ID,
            title: role == EMessageRole.user ? 'You' : 'Assistant',
            channelKey: 'topics_chat_channel',
            body: role != EMessageRole.imageAssistant ? body : null,
            bigPicture: role == EMessageRole.imageAssistant ? body : null,
            largeIcon: isLoading
                ? 'asset://assets/images/loading.png'
                : role == EMessageRole.imageAssistant
                    ? null
                    : 'asset://assets/images/topics_dark_removebg.png',
            hideLargeIconOnExpand: true,

            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: role == EMessageRole.imageAssistant
                ? NotificationLayout.BigPicture
                : NotificationLayout.BigText,
            payload: {'notificationId': '$CHAT_NOTIFICATION_ID'}),
        actionButtons: [
          NotificationActionButton(
              key: TEXT_GENERATION_KEY,
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: IMAGE_GENERATION_KEY,
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
