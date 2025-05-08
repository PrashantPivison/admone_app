// notification_model.dart should have const constructor:
class NotificationModel {
  final String title;
  final String body;
  final DateTime receivedAt;

  const NotificationModel({
    required this.title,
    required this.body,
    required this.receivedAt,
  });
}
