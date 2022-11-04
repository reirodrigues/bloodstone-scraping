import 'dart:convert' as convert;
import 'package:app/pages/pages_tabs/tabela_xp/components/models/form.dart';
import 'package:http/http.dart' as http;

class FormController {
  Future<List<TableForm>> getTableList(String url) async {
    return await http.get(Uri.parse(url)).then(
      (response) {
        var jsonTable = convert.jsonDecode(response.body) as List;
        return jsonTable.map((json) => TableForm.fromJson(json)).toList();
      },
    );
  }
}
