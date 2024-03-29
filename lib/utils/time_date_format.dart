import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeDateFormat {
  static String getTimeformat(BuildContext context, String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(BuildContext context, String time) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return "${sent.day} ${getMonth(sent)}";
  }

  static String getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }
    return "N/A";
  }

  String getLastActiveTime(BuildContext context, String lastActive) {
    final int i = int.parse(lastActive);

    if (i == -1) return "Last seen not available";

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return "Last seen today at $formattedTime";
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return "Last seen yesterday at $formattedTime";
    }
    String month = getMonth(time);
    return "Last seen on ${time.day} $month at $formattedTime";
  }
}
