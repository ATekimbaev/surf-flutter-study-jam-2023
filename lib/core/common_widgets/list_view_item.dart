import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  const Item(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.isDownload});

  final String title;
  final Function() onPressed;
  final bool isDownload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.green,
          child: Row(
            children: [
              const Icon(Icons.train),
              Text(
                title.substring(35),
                softWrap: true,
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                    isDownload ? Icons.cloud_sync_outlined : Icons.download),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
