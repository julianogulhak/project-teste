
import 'package:flutter_application_1/model/pessoa.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class PessoaHelper {
  static final PessoaHelper _instance = PessoaHelper.internal();

  factory PessoaHelper() => _instance;

  PessoaHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "todo_list.db");

    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
          await db.execute("CREATE TABLE pessoa("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "nome TEXT, "
              "dtNascimento TEXT, "
              "sexo int)");
        });
  }

  Future<Pessoa> save(Pessoa pessoa) async {
    Database database = await db;
    pessoa.id = await database.insert('PESSOA', pessoa.toMap());
    return pessoa ;
  }



  Future<List<Pessoa>> getAll() async {
    Database database = await db;
    List listMap = await database.rawQuery("SELECT * FROM pessoa");
    List<Pessoa> pessoasList = listMap.map((x) => Pessoa.fromMap(x)).toList();
    return pessoasList;
  }

  Future<int> update(Pessoa pessoa) async {
    Database database = await db;
    return await database
        .update('pessoa', pessoa.toMap(), where: 'id = ?', whereArgs: [pessoa.id]);
  }

  Future<int> delete(int id) async {
    Database database = await db;
    return await database.delete('pessoa', where: 'id = ?', whereArgs: [id]);
  }
}