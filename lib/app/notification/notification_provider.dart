import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:topics/services/permission_service.dart';

class NotificationProvider extends ChangeNotifier {
  ReceivedNotification? _receivedNotification;
  ReceivedAction? _receivedAction;

  ReceivedNotification? get receivedNotification => _receivedNotification;
  ReceivedAction? get receivedAction => _receivedAction;

  Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    _receivedNotification = receivedNotification;
    notifyListeners(); // Notify listeners when the notification data is updated
  }

  Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    _receivedNotification = receivedNotification;
    notifyListeners(); // Notify listeners when the notification data is updated
  }

  Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    _receivedAction = receivedAction;
    notifyListeners(); // Notify listeners when the action data is updated
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      print(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      // await executeLongTaskInBackground();
    } else {}
  }

  Future<void> createChatNotification() async {
    if (await permissionServiceProvider.requestNotificationsPermission()) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: -1, // -1 is replaced by a random number
              channelKey: 'alerts',
              title: 'Huston! The eagle has landed!',
              body:
                  "A small step for a man, but a giant leap to Flutter's community!",
              bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
              largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
              //'asset://assets/images/balloons-in-sky.jpg',
              notificationLayout: NotificationLayout.BigPicture,
              payload: {'notificationId': '1234567890'}),
          actionButtons: [
            NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
            NotificationActionButton(
                key: 'REPLY',
                label: 'Reply Message',
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
