// core/utils/date_utils.dart
class AppDateUtils {
  static DateTime now() => DateTime.now();

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }
}