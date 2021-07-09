class Pessoa {
  int id;
  String nome;
  DateTime dtNascimento;
  int sexo;
  bool isDone;

  Pessoa({
    this.id,
    this.nome,
    this.dtNascimento,
    this.sexo,
  });

  factory Pessoa.fromMap(Map<String, dynamic> json) => new Pessoa(
    id: json["id"],
    nome: json["nome"],
    dtNascimento: DateTime.parse(json["dtNascimento"]),
    sexo: json["sexo"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nome": nome,
    "dtNascimento": dtNascimento.toString(),
    "sexo": sexo,
  };
}