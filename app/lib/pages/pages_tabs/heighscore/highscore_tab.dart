import 'package:app/components/custom_shimer.dart';
import 'package:app/pages/pages_tabs/heighscore/components/category_tile.dart';
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
  List<Player> players = [];
  List<Player> jogadores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getWebsiteData();
  }

  String server = '2';

  Future getWebsiteData() async {
    final url = Uri.parse('https://www.bloodstoneonline.com/pt/pontuacao/');
    final request = http.MultipartRequest('POST', url);
    request.fields['server'] = server;
    request.fields['vocation'] = '0';
    request.fields['category'] = '0';

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);

    dom.Document html = dom.Document.html(responsed.body);

    final dados = html
        // .querySelectorAll('table > tbody > tr > td:nth-child(3)')
        .querySelectorAll('table > tbody > tr')
        .map((element) => element.innerHtml
            .replaceAll('<td>', '')
            .replaceAll(RegExp('[^a-zA-Zà-úÀ-Ú0-9 ]'), '')
            .trim()
            .split('td'))
        .toList();
    List<List<String>> players = [];

    for (List<String> nome in dados) {
      List<String> user = nome;
      user.removeAt(user.length - 1);
      players.add(user);
    }

    setState(() {
      jogadores = List.generate(
        players.length,
        (index) => Player(
          rank: players[index][0],
          name: players[index][1],
          vocation: players[index][2],
          level: players[index][4],
          experience: players[index][5],
        ),
      );
    });

    setState(() {
      isLoading = false;
    });
  }

  List<String> categories = [
    'Ruby',
    'Onix',
  ];

  String selectCategory = 'Ruby';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //---------------------------------------------------------------------- categories
          Container(
            padding: const EdgeInsets.only(left: 100),
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, index) {
                return const SizedBox(
                  width: 50,
                );
              },
              itemBuilder: (_, index) {
                return CategorieTile(
                  category: categories[index],
                  isSelected: categories[index] == selectCategory,
                  onPressed: () {
                    setState(() {
                      selectCategory = categories[index];
                    });

                    if (selectCategory == 'Onix') {
                      setState(() {
                        server = '1';
                        isLoading = true;
                        getWebsiteData();
                      });
                    } else {
                      setState(() {
                        server = '2';
                        isLoading = true;
                        getWebsiteData();
                      });
                    }
                  },
                );
              },
            ),
          ),
          //----------------------------------------------------------------------
          Expanded(
            child: !isLoading
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: jogadores.length,
                    itemBuilder: ((context, index) {
                      final jogador = jogadores[index];

                      return InkWell(
                        onTap: () async {},
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                              child: ListTile(
                                leading: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  child: Text(
                                    jogador.rank,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                title: Text(
                                  jogador.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle:
                                    Text('Expeciência: ${jogador.experience}'),
                                trailing: Text(
                                  '${jogador.vocation} ${jogador.level}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    children: List.generate(
                      10,
                      (index) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: CustomShimmer(
                          height: 60,
                          width: 50,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
