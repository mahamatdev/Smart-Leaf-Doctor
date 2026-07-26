// lib/screens/best_practices_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BestPracticesScreen extends StatelessWidget {
  const BestPracticesScreen({super.key});

  Widget _buildTip(String title, String desc, IconData icon, Color color) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(title),
        subtitle: Text(desc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('best_practices'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('field_tips'.tr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTip('tip_photo'.tr, 'photo_tip1'.tr, Icons.camera_alt, Colors.orange),
            _buildTip('tip_light'.tr, 'photo_tip2'.tr, Icons.wb_sunny, Colors.yellow.shade700),
            _buildTip('tip_single_leaf'.tr, 'photo_tip3'.tr, Icons.scatter_plot, Colors.green),
            _buildTip('tip_distance'.tr, 'photo_tip4'.tr, Icons.zoom_out_map, Colors.blue),
            const SizedBox(height: 20),
            Text('farm_management'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('farm_management_text'.tr),
          ],
        ),
      ),
    );
  }
}
