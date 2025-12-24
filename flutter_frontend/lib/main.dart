// ==================== lib/main.dart ====================
import 'package:flutter/material.dart';
import 'screens/kegiatan_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kegiatan App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: KegiatanPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
