import 'package:intl/intl.dart';

String formatLastMessageTime(DateTime timestamp) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

  // Check if the message was sent today
  if (messageDate.isAtSameMomentAs(today)) {
    return DateFormat.jm().format(timestamp);
  }

  // Check if the message was sent yesterday
  if (messageDate.isAtSameMomentAs(yesterday)) {
    return 'Yesterday, ${DateFormat.jm().format(timestamp)}';
  }

  // Otherwise, show the full date and time
  return DateFormat('d MMM yyyy, h:mm a').format(timestamp);
}
