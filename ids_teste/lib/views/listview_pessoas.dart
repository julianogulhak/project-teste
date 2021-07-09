import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/bancoHelper.dart';
import 'package:flutter_application_1/diolog/baseDialog.dart';
import 'package:flutter_application_1/model/pessoa.dart';
import 'package:flutter_application_1/utils/format_utils.dart';
import 'package:flutter_application_1/diolog/mensagem_confirmacao.dart';
import 'package:flutter_application_1/views/cadPessoa.dart';

class ListViewPessoas extends StatefulWidget {
  @override
  _ListViewPessoasState createState() => new _ListViewPessoasState();
}

class _ListViewPessoasState extends State<ListViewPessoas> {
  List<Pessoa> pessoas = new List();

  @override
  Future<void> initState() {
    super.initState();
    PessoaHelper.internal().getAll().then((value) {
      setState(() {
        pessoas.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lista Pessoa',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pessoas'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: pessoas.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ListTile(
                        title: Text(
                          '${pessoas[position].nome.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          'Idade:${FormatUtils.instance.calculaIdade(pessoas[position].dtNascimento).toString()}',
                          style: new TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        onTap: () =>
                            showMensage(context, pessoas[position], position),
                      ),
                    ),
                    Divider(height: 5.0),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewPessoa(context),
        ),
      ),
    );
  }

  void navigateToCad(BuildContext context, Pessoa pessoa) async {
    String result = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
          builder: (_) => CadPessoas(
                pessoa: pessoa,
              )),
    );
    Navigator.pop(context);
    if (result == "alterado") {
      List<Pessoa> list = await PessoaHelper.internal().getAll();
      setState(() {
        pessoas.clear();

        pessoas.addAll(list);
      });
    }
  }

  void _createNewPessoa(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadPessoas()),
    );
    List<Pessoa> list = await PessoaHelper.internal().getAll();

    if (list != pessoas) {
      setState(() {
        pessoas.clear();
        pessoas.addAll(list);
      });
    }
  }

  void deleteCad(BuildContext context, Pessoa pessoa, int position) async {
    if (await showConfirmMessage(
            context, "Confirma a exclusão deste cadastro de despesa?") ==
        MensagemConfirmacao.CONFIRM) {
      PessoaHelper.internal().delete(pessoa.id).then((pessoa) async {
        if (pessoa == 1) {
          await showSimpleMessage(
              context, "Cadastro de despesa excluído com sucesso.");
          setState(() {
            pessoas.removeAt(position);
            Navigator.pop(context);
          });
        } else {
          showSimpleMessage(context,
              "Não foi possível excluir o cadastro de despesa, tente novamente mais tarde.");
        }
      }).catchError((onError) {
        showSimpleMessage(context,
            "Ocorreu o seguinte erro ao excluir o cadastro de despesa: ${onError.message}");
      });
    }
  }

  Future showMensage(
      BuildContext showContext, Pessoa pessoa, int position) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => BaseAlertDialog(
        title: Text("selecione"),
        content: Container(
          height: 140,
          child: Column(children: <Widget>[
            ListTile(
                title: Text(
                  "editar",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  return navigateToCad(context, pessoa);
                }),
            ListTile(
              title: Text(
                "Excluir",
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black87,
                ),
              ),
              onTap: () => deleteCad(context, pessoa, position),
            ),
          ]),
        ),
      ),
    );
  }
}
