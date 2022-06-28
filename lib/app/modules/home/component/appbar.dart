import 'package:flutter/material.dart';

AppBar appBar(String text) {
  Widget title = Text(text);
  if (text.contains('assets')) {
    title = Image.asset(text, fit: BoxFit.fill, height: 80);
  } else {
    title = Text(text);
  }
  return AppBar(
    title: title,
    centerTitle: true,
  );
}
