import 'package:flutter/material.dart';
import 'package:pulse/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.init();

  runApp(const MaterialApp());
}