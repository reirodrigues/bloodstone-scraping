import 'package:app/models/streamer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.streamer,
  });

  final Streamer streamer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print(streamer.url);
        final Uri url = Uri.parse(streamer.url);

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
                  streamer.urlImage,
                ),
              ),
              //--------------------------------------------------------- Nick
              Text(
                streamer.nick,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //--------------------------------------------------------- views
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 8,
                ),
                child: Text(
                  streamer.spectators,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
              ),
              //--------------------------------------------------------- description
              SizedBox(
                height: 100,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        streamer.description,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
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
