import 'package:cloud_firestore/cloud_firestore.dart';

DateTime convertDate(Timestamp dateInput) {
  return dateInput.toDate();
}

bool compareCreateDate(DateTime createDateTime) {
  DateTime now = DateTime.now();

  return createDateTime.day == now.day &&
      createDateTime.month == now.month &&
      createDateTime.year == now.year;
}
