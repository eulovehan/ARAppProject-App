import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PopupdialogType {
  success,
  warning,
  error,
  info,
  confirm,
  none,
}

enum DataTableStatus {
  none,
  empty,
  loading,
  data,
  error
}


class DialogActionInfo {
  final int index;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;
  final Color? backgroundColor;
  final Function? onPressed;

  const DialogActionInfo({
    required this.index,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.onPressed
  });
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class CustomException implements Exception {
  final String message;

  CustomException(this.message);

  @override
  String toString() {
    return message;
  }
}