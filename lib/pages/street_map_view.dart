import 'package:flutter/material.dart';
import 'package:helpwave/components/street_map.dart';

class StreetMapViewPage extends StatelessWidget {
  const StreetMapViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "helpwave",
        ),
      ),
      body: const Center(child: StreetMap()),
    );
  }
}
