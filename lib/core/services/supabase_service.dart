import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://kbtlkjcclkquyhiwpaet.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtidGxramNjbGtxdXloaXdwYWV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYwNzU4NTIsImV4cCI6MjA5MTY1MTg1Mn0.oUZG5QSBpZMdPP-shXF_KnymHOdomVUw4aW6pUMtC8A',
    );
  }

  SupabaseClient get client => Supabase.instance.client;
}