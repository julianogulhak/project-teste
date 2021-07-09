import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/bancoHelper.dart';
import 'package:flutter_application_1/diolog/baseDialog.dart';
import 'package:flutter_application_1/model/pessoa.dart';
import 'package:flutter_application_1/utils/format_utils.dart';

import '../diolog/mensagem_confirmacao.dart';
import '../utils/page_state.dart';

class CadPessoas extends StatefulWidget {
  final Pessoa pessoa;

  CadPessoas({Key key, this.pessoa}) : super(key: key);

  @override
  _CadPessoasState createState() => _CadPessoasState();
}

class _CadPessoasState extends State<CadPessoas>
    with SingleTickerProviderStateMixin, PageState {
  Pessoa _pessoa;
  List<String> _tipoSexo;
  bool _isAutoValidate = false, _isActionPressed = false;
  TextEditingController _dataController, _idadeController, _nomeController;
  FocusNode _valorFocus, _documentoFocus, _descricaoFocus;
  GlobalKey<FormState> _formKey;

  @override
  void instanceMethods() {
    _valorFocus = FocusNode();
    _documentoFocus = FocusNode();
    _descricaoFocus = FocusNode();
    _dataController = TextEditingController();
    _nomeController = TextEditingController();
    _idadeController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _tipoSexo = ["Masculino", "Feminino"];
  }

  @override
  Future initMethods() async {
    if (widget.pessoa != null) {
      _pessoa = widget.pessoa;
      _nomeController.text = _pessoa.nome;
      _dataController.text =
          FormatUtils.instance.calculaIdade(_pessoa.dtNascimento).toString();
    } else {
      _pessoa = Pessoa(nome: '', dtNascimento: DateTime.now(), sexo: 0);
    }
  }

  @override
  void dispose() {
    _dataController.dispose();
    _idadeController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title:
                Text(_pessoa?.id == null ? "Novo Cadastro" : "Editar cadastro"),
            centerTitle: false,
            titleSpacing: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              tooltip: "Cancelar",
              onPressed: () async {
                if (!_isActionPressed) {
                  _isActionPressed = true;
                  if (await showConfirmMessage(context,
                          "Deseja realmente sair") ==
                      MensagemConfirmacao.CONFIRM) {
                      Navigator.pop(context);

                    }
                  }
                  _isActionPressed = false;
                }

            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.check_circle),
                tooltip: "Salvar",
                onPressed: () async {
                  if (!_isActionPressed) {
                    _isActionPressed = true;
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (_pessoa.id == null) {
                        PessoaHelper.internal()
                            .save(_pessoa)
                            .then((status) async {
                          if (status.id > 0) {
                            await showSimpleMessage(
                                context, "O cadastro  foi salvo com sucesso.",
                                title: "Operação realizada");
                            Navigator.pop(context, 'alterado');
                          } else {
                            BaseAlertDialog(
                              title: Text("Atenção"),
                              content: Text(
                                  "Não foi possível salvar o cadastro , tente novamente mais tarde."),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text("CONFIRMAR"),
                                    textColor: Colors.blue,
                                    onPressed: () => Navigator.pop(context)),
                              ],
                            );
                          }
                        }).catchError((onError) {
                          BaseAlertDialog(
                            title: Text("Atenção"),
                            content: Text(
                                "Ocorreu o seguinte erro ao salvar o cadastro : ${onError.message}"),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text("CONFIRMAR"),
                                  textColor: Colors.blue,
                                  onPressed: () => Navigator.pop(context)),
                            ],
                          );
                        });
                      } else {
                        if (_pessoa.id != null) {
                          PessoaHelper.internal()
                              .update(_pessoa)
                              .then((status) async {
                            if (status > 0) {
                              await showSimpleMessage(context,
                                  "O cadastro foi atualizado com sucesso.",
                                  title: "Parabéns");
                              Navigator.pop(context, 'alterado');
                            } else {
                              showSimpleMessage(context,
                                  "Não foi possível atualizar o cadastro, tente novamente mais tarde.");
                            }
                          }).catchError((onError) {
                            showSimpleMessage(context,
                                "Ocorreu o seguinte erro ao atualizar o cadastro : ${onError.message}");
                          });
                        }
                      }
                    }
                  }
                  _isActionPressed = false;
                },
              ),
            ]),
        body: Form(
          key: _formKey,
          autovalidateMode: _isAutoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          onChanged: () => setState(() => _isAutoValidate = true),
          child: SingleChildScrollView(
            primary: true,
            child: Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                    child: TextFormField(
                      focusNode: _documentoFocus,
                      controller: _nomeController,
                      maxLength: 40,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        isDense: false,
                        labelStyle: TextStyle(fontSize: 18),
                        labelText: "Nome",
                        hintText: "Não informado",
                        prefix: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(""),
                        ),
                      ),
                      onSaved: (value) => _pessoa.nome = value,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Campo obrigatório";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _documentoFocus.unfocus();
                        FocusScope.of(context).requestFocus(_descricaoFocus);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: TextField(
                      controller: _dataController,
                      readOnly: true,
                      autofocus: false,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        isDense: false,
                        labelStyle: TextStyle(fontSize: 18),
                        labelText: 'Idade',
                        prefix: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(""),
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(left: 25, top: 16),
                          child: Icon(
                            Icons.today,
                            size: 24,
                          ),
                        ),
                      ),
                      onTap: () async {
                        DateTime dateTime = await showDatePicker(
                            context: context,
                            firstDate: FormatUtils.dateOnly(
                                DateTime.now().subtract(Duration(days: 36500))),
                            lastDate: FormatUtils.dateOnly(DateTime.now()),
                            initialDate: FormatUtils.dateOnly(
                                _pessoa.dtNascimento ?? DateTime.now()),
                            helpText: "SELECIONE A DATA DE NASCIMENTO",
                            cancelText: "CANCELAR",
                            confirmText: "CONFIRMAR");
                        if (dateTime != null) {
                          var idade = FormatUtils.instance
                              .calculaIdade(dateTime)
                              .toString();
                          setState(()  {
                            _pessoa.dtNascimento = DateTime(
                                dateTime.year,
                                dateTime.month,
                                dateTime.day,
                                dateTime.hour,
                                dateTime.minute,
                                0,
                                0,
                                0);
                              _dataController.text = idade;
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32, left: 16, right: 16),
                    child: Text(
                      "Sexo",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: DropdownButtonFormField<String>(
                      value: _tipoSexo[_pessoa?.sexo ?? 0],
                      hint: Text(
                        'choose one',
                      ),
                      isExpanded: true,
                      onChanged: (value) => setState(
                          () => _pessoa?.sexo = _tipoSexo.indexOf(value)),
                      onSaved: (value) {
                        setState(() {
                          _pessoa?.sexo = _tipoSexo.indexOf(value);
                        });
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "can't empty";
                        } else {
                          return null;
                        }
                      },
                      items: _tipoSexo.map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Padding(
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
