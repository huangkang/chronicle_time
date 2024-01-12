import 'package:date_format/date_format.dart';

class FormatDateUtils {
  static String formatDateTime(DateTime dateTime) {
    return formatDate(
        dateTime, [yyyy, '-', mm, '-', dd, ' ', HH, ':', mm, ':', ss]);
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
