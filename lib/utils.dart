import 'dart:math';

String getImage() {
  final random = Random();
  return 'https://picsum.photos/300/200?hash=${random.nextInt(10000)}';
}

String diffTimeString(DateTime dateTime) {
  final curTime = DateTime.now();
  final diffMSec =
      curTime.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;
  String result;
  if (diffMSec < 60 * 60 * 1000) {
    result = "${(diffMSec / (60 * 1000)).round()}m";
  } else if (diffMSec < 24 * 60 * 60 * 1000) {
    result = "${(diffMSec / (60 * 60 * 1000)).round()}h";
  } else {
    result = "${(diffMSec / (24 * 60 * 60 * 1000)).round()}d";
  }
  return result;
}

String shortNumberFormat(int number) {
  if (number > 1000000000) {
    return "${(number / 1000000).toStringAsFixed(1)}B";
  } else if (number > 1000000) {
    return "${(number / 1000000).toStringAsFixed(1)}M";
  } else if (number > 1000) {
    return "${(number / 1000).toStringAsFixed(1)}K";
  }

  return number.toString();
}
