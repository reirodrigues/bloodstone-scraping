/// FeedbackForm is a data class which stores data fields of Feedback.
class TableForm {
  String nome;
  String classe;
  String expRecente;
  String expInicial;
  String ganhoDeExp;

  TableForm(
    this.nome,
    this.classe,
    this.expRecente,
    this.expInicial,
    this.ganhoDeExp,
  );

  factory TableForm.fromJson(dynamic json) {
    return TableForm(
      "${json['nome']}",
      "${json['classe']}",
      "${json['expRecente']}",
      "${json['expInicial']}",
      "${json['ganhoDeExp']}",
    );
  }

  // Method to make GET parameters.
  Map toJson() => {
        'nome': nome,
        'classe': classe,
        'expRecente': expRecente,
        'expInicial': expInicial,
        'ganhoDeExp': ganhoDeExp,
      };
}
