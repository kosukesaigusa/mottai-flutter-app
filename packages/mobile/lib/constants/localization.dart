import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const locale = Locale('ja', 'JP');

const localizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
