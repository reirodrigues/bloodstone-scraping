import 'package:app/components/custom_shimer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:app/models/article.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({super.key});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  List<Article> articles = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse('https://www.bloodstoneonline.com/pt/noticias/');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll('p > a.f-white')
        .map((element) => element.innerHtml.trim())
        .toList();

    final urls = html
        .querySelectorAll('p > a.f-white')
        .map((element) =>
            'https://www.bloodstoneonline.com${element.attributes['href']}')
        .toList();

    final urlImages = html
        .querySelectorAll('div > a > picture > img')
        .map((element) => element.attributes['src']!)
        .toList();

    final dates = html
        .querySelectorAll('div > div > h3')
        .map((element) => element.innerHtml.trim())
        .toList();

    setState(() {
      articles = List.generate(
        titles.length,
        (index) => Article(
          title: titles[index],
          url: urls[index],
          urlImage: urlImages[index],
          date: dates[index],
        ),
      );
    });

    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'ÚLTIMAS NOVIDADES',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: articles.length,
                    itemBuilder: ((context, index) {
                      final article = articles[index];

                      return InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse(article.url);

                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: ListTile(
                                leading: Image.network(
                                  article.urlImage,
                                  width: 50,
                                  fit: BoxFit.fitHeight,
                                ),
                                title: Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                                subtitle: Text(article.date),
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
                          height: 80,
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
