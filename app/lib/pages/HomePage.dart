import 'package:app/pages/pages_tabs/heighscore/highscore_tab.dart';
import 'package:app/pages/pages_tabs/news/news_tab.dart';
import 'package:app/pages/pages_tabs/shop/shop_tab.dart';
import 'package:app/pages/pages_tabs/streamers/streamers_tab.dart';
import 'package:app/pages/pages_tabs/tabela_xp/tabela_xp_tab.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          NewsTab(),
          HighScoreTab(),
          StreamersTab(),
          TabelaXpTab(),
          ShopTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                currentIndex = index;
                pageController.jumpToPage(index);
              });
            },
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.brown,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withAlpha(100),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.data_thresholding_sharp),
                label: 'Highscore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.desktop_windows),
                label: 'Streamers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assessment_outlined),
                label: 'Experience',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Shop',
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 100,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(26, 10, 26, 0),
        child: Image.asset('assets/images/logo.png'),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      )),
    );
  }
}
