import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: EmptyStateList(
        imageAssetName: 'assets/images/folder.png',
        title: 'Ooops... there are no study sessions here',
        description: "Tap the '+' button to add a new study session",
      ),
    ),
  ));
}

class EmptyStateList extends StatelessWidget {
  final String imageAssetName;
  final String title;
  final String description;

  const EmptyStateList(
      {super.key,
      required this.imageAssetName,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageAssetName,
            width: 100,
            height: 100,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(title),
          const SizedBox(
            height: 16,
          ),
          Text(description),
        ],
      ),
    );
  }
}
