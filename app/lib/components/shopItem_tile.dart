import 'package:app/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopItemTile extends StatelessWidget {
  const ShopItemTile({
    super.key,
    required this.shop,
  });

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(shop.url);

        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw 'Could not launch $url';
        }
      },
      child: Card(
        elevation: 15,
        shadowColor: Colors.brown.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //--------------------------------------------------------- image
              Expanded(
                child: Image.network(
                  shop.urlImage,
                  width: 120,
                  height: 120,
                ),
              ),
              //--------------------------------------------------------- Title
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  shop.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //--------------------------------------------------------- description
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    shop.description,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
