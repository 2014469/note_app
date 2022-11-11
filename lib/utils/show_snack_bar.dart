import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

void showSnackBarError(BuildContext context, String text) {
  showTopSnackBar(
    context,
    CustomSnackBar.error(message: text),
  );
}

void showSnackBarInfo(BuildContext context, String text) {
  showTopSnackBar(
    context,
    CustomSnackBar.info(message: text),
  );
}

void showSnackBarSuccess(BuildContext context, String text) {
  showTopSnackBar(
    context,
    CustomSnackBar.success(message: text),
  );
}
