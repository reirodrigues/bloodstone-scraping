import 'package:app/components/shopItem_tile.dart';
import 'package:app/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  List<Shop> shop = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse('https://www.bloodstoneonline.com/pt/loja/');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll('div.last-news-description-holder > h3')
        .map((element) => element.innerHtml.trim())
        .toList();

    final urls = html
        .querySelectorAll('p > a.f-white')
        .map((element) =>
            'https://www.bloodstoneonline.com/pt/loja/${element.attributes['href']}')
        .toList();

    final urlImages = html
        .querySelectorAll('div.last-news-holder > div > a > img')
        .map((element) =>
            'https://www.bloodstoneonline.com${element.attributes['src']}')
        .toList();

    final descriptions = html
        .querySelectorAll('div.last-news-description-holder > p > a.f-white')
        .map((element) => element.innerHtml.trim())
        .toList();

    setState(() {
      shop = List.generate(
        titles.length,
        (index) => Shop(
          title: titles[index],
          url: urls[index],
          urlImage: urlImages[index],
          description: descriptions[index],
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
              'LOJA',
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
                      crossAxisCount: 2,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 10,
                      childAspectRatio: 9 / 12.5,
                    ),
                    itemCount: shop.length,
                    itemBuilder: (_, index) {
                      return ShopItemTile(
                        shop: shop[index],
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
