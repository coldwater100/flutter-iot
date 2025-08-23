import 'package:flutter/material.dart';
import '../../disease/domain/disease_entity.dart';

class DiseaseDetailPage extends StatelessWidget {
  final DiseaseEntity record;
  const DiseaseDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(record.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(record.imagePath),
            ),
            const SizedBox(height: 20),
            Text(record.date,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(record.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(record.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
