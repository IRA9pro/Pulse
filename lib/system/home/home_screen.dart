import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth_provider.dart';
import '../../core/theme/pulse_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: PulseTheme.background,
            title: Text(
              "PULSE",
              style: textTheme.displayLarge?.copyWith(fontSize: 24),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: PulseTheme.neonCyan),
                onPressed: () => ref.read(authServiceProvider).signOut(),
                tooltip: "Logout",
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                _BentoTile(
                  title: "Tasks",
                  icon: Icons.checklist_rounded,
                  color: PulseTheme.neonCyan,
                ),
                _BentoTile(
                  title: "Journal",
                  icon: Icons.auto_stories_rounded,
                  color: Colors.purpleAccent,
                ),
                _BentoTile(
                  title: "Focus",
                  icon: Icons.timer_rounded,
                  color: Colors.orangeAccent,
                ),
                _BentoTile(
                  title: "Health",
                  icon: Icons.favorite_rounded,
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _BentoTile({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PulseTheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
