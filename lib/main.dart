import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize StorageService
  await StorageService.init();

  runApp(const MyApp());
}
