import 'package:app/components/item_tile.dart';
import 'package:app/models/streamer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class StreamersTab extends StatefulWidget {
  const StreamersTab({super.key});

  @override
  State<StreamersTab> createState() => _StreamersTabState();
}

class _StreamersTabState extends State<StreamersTab> {
  List<Streamer> streamers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse('https://www.bloodstoneonline.com/pt/twitch/');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    // ------------------------------------------------------------------------ Nicks
    final nicks = html
        .querySelectorAll('div.news-each > div > h3')
        .map((element) => element.innerHtml.trim())
        .toList();

    print('Count: ${nicks.length}');
    for (final nick in nicks) {
      debugPrint(nick);
    }

    // ------------------------------------------------------------------------ url

    final urls = html
        .querySelectorAll('div > div.news-each > a')
        .map((element) => '${element.attributes['href']}')
        .toList();

    print('Count: ${urls.length}');
    for (final url in urls) {
      debugPrint(url);
    }

    // ------------------------------------------------------------------------ Images

    final urlImages = html
        .querySelectorAll('div.news-each > a > picture > img')
        .map((element) => element.attributes['src']!)
        .toList();
    print('Count: ${urlImages.length}');
    for (final urlImage in urlImages) {
      debugPrint(urlImage);
    }

    // ------------------------------------------------------------------------ spectators

    final spectators = html
        .querySelectorAll('div.news-each > div > span')
        .map((element) => element.innerHtml.trim())
        .toList();

    print('Count: ${nicks.length}');
    for (final nick in nicks) {
      debugPrint(nick);
    }

    // ------------------------------------------------------------------------ descriptions

    final descriptions = html
        .querySelectorAll('div.news-each > div > p > a.f-white')
        .map((element) => element.innerHtml.trim())
        .toList();

    print('Count: ${nicks.length}');
    for (final nick in nicks) {
      debugPrint(nick);
    }

    setState(() {
      streamers = List.generate(
        nicks.length,
        (index) => Streamer(
          nick: nicks[index],
          spectators: spectators[index],
          description: descriptions[index],
          urlImage: urlImages[index],
          url: urls[index],
        ),
      );
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            // ----------------------------------------------------- Heade
            child: Text(
              'Streamers Online',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // -------------------------------------------------------------- Gridview
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                :
                // streamers.length != null ?
                GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 10,
                      childAspectRatio: 9 / 10,
                    ),
                    itemCount: streamers.length,
                    itemBuilder: (_, index) {
                      return ItemTile(
                        streamer: streamers[index],
                      );
                    },
                  ),
          )
          // Categories(),
        ],
      ),
    );
  }
}
