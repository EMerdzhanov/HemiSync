import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/player/presentation/screens/player_screen.dart';
import 'features/presets/presentation/screens/presets_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

class HemiSyncApp extends ConsumerWidget {
  const HemiSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    // Keep screen on during sessions if enabled
    if (settings.keepScreenOn) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    return MaterialApp(
      title: 'HemiSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const PlayerScreen(),
      routes: {
        '/presets': (context) => const PresetsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
