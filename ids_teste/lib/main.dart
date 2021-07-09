import 'package:flutter/material.dart';

import 'package:flutter_application_1/views/listview_pessoas.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() => runApp(MaterialApp(
  title: 'App IDS',
  localizationsDelegates: [GlobalMaterialLocalizations.delegate],
  supportedLocales: [const Locale('pt')],
  home: ListViewPessoas(),
),);



