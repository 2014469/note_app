import 'package:cloud_firestore/cloud_firestore.dart';

DateTime convertDate(Timestamp dateInput) {
  return dateInput.toDate();
}
