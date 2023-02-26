import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final image_saved_toast = Fluttertoast.showToast(
  msg: "Image saved",
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 2,
  backgroundColor: Colors.red,
  textColor: Colors.white,
  fontSize: 16.0,
);
