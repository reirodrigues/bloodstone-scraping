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
    final request = http.MultipartRequest('POST', url);
    request.fields['server'] = '2';
    request.fields['vocation'] = '0';
    request.fields['category'] = '0';

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);

    dom.Document html = dom.Document.html(responsed.body);

    final nomes = html
        .querySelectorAll('table > tbody > tr > td:nth-child(3)')
        .map((element) => element.innerHtml.trim())
        .toList();

    if (response.statusCode == 200) {
      print("SUCCESS");
      print(responsed.body);
    } else {
      print("ERROR");
    }

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
