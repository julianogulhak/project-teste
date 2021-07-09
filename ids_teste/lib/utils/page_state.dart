import 'package:flutter/material.dart';

import '../diolog/baseDialog.dart';
import '../diolog/mensagem_confirmacao.dart';


mixin PageState<T extends StatefulWidget> on State<T> {
  @protected
  void instanceMethods() {}

  @protected
  void implementsMethods() {}

  @protected
  Future<void> initMethods() async {}

  @protected
  Future<bool> onBackPressed() async {
    return true;
  }

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    instanceMethods();
    implementsMethods();
    initMethods();
  }





}
