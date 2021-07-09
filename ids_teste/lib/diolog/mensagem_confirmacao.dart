import 'package:flutter/material.dart';
import 'package:flutter_application_1/diolog/baseDialog.dart';
import 'package:flutter_application_1/model/pessoa.dart';

enum MensagemConfirmacao { NEUTRAL, CANCEL, CONFIRM }


@protected
Future<MensagemConfirmacao> showConfirmMessage(BuildContext context,
    String message,
    {String title,
      String confirmText,
      String cancelText,
      String neutralText}) async {
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          BaseAlertDialog(
              title: Text(title ?? "Atenção"),
              content: Text(message),
              actions: <Widget>[
                Visibility(
                  visible: neutralText != null,
                  child: FlatButton(
                      child: Text(neutralText ?? ""),
                      textColor: Colors.blue,
                      onPressed: () =>
                          Navigator.pop(context, MensagemConfirmacao.NEUTRAL)),
                ),
                FlatButton(
                    child: Text(cancelText ?? "CANCELAR"),
                    textColor: Colors.blue,
                    onPressed: () =>
                        Navigator.pop(context, MensagemConfirmacao.CANCEL)),
                FlatButton(
                    child: Text(confirmText ?? "CONFIRMAR"),
                    textColor: Colors.blue,
                    onPressed: () =>
                        Navigator.pop(context, MensagemConfirmacao.CONFIRM))
              ]));
}

@protected
Future showSimpleMessage(BuildContext context, String message,
    {String title, String confirmText}) async {
  return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) =>
          BaseAlertDialog(
            title: Text(title ?? "Atenção"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                  child: Text(confirmText ?? "CONFIRMAR"),
                  textColor: Colors.blue,
                  onPressed: () => Navigator.pop(context)),
            ],
          ));
}




