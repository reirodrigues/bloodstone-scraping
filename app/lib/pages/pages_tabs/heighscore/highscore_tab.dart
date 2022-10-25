import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

import '../../../models/players.dart';

class HighScoreTab extends StatefulWidget {
  const HighScoreTab({super.key});

  @override
  State<HighScoreTab> createState() => _HighScoreTabState();
}

class _HighScoreTabState extends State<HighScoreTab> {
  List<Players> players = [];

  @override
  void initState() {
    super.initState();

    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse('https://www.bloodstoneonline.com/pt/pontuacao/');
    final response = await http
        .post(url, body: {'server': '0', 'vocation': '0', 'category': '0'});
    dom.Document html = dom.Document.html(response.body);

    final nomes = html
        .querySelectorAll('.table, .table-bordered, .dataTable')
        .map((element) => element.innerHtml.trim())
        .toList();

    print('Count: ${nomes.length}');
    for (final nome in nomes) {
      debugPrint(nome);
    }

    setState(() {
      players = List.generate(
        nomes.length,
        (index) => Players(
          classificacao: nomes[index],
          nome: '',
          vocacao: '',
          nivel: '',
          experiencia: '',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
