import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/core/role/app_role.dart';
import 'package:her/core/role/role_provider.dart';
import 'package:her/features/cycle/domain/cycle_phase.dart';
import 'package:her/features/him/providers/partner_data_provider.dart';
import 'package:her/features/cycle/utils/cycle_calculator.dart';
import 'package:her/features/cycle/data/cycle_repository.dart';

part 'daily_content_provider.g.dart';

@riverpod
Future<Map<String, String>> dailyContent(DailyContentRef ref) async {
  final role = ref.watch(currentRoleProvider);

  if (role == AppRole.her) {
    final entries = await ref
        .watch(cycleRepositoryProvider)
        .watchCycleEntries()
        .first;
    if (entries.isEmpty) {
      return {
        'title': 'Welcome to Luna',
        'content':
            'Log your first period to start receiving personalized daily insights.',
      };
    }
    final phase = CycleCalculator.calculate(entries).phase;

    switch (phase) {
      case CyclePhase.menstrual:
        return {
          'title': 'Gentle Care',
          'content':
              'Your body is working hard. Prioritize rest and warmth today.',
        };
      case CyclePhase.follicular:
        return {
          'title': 'New Beginnings',
          'content':
              'Energy levels are rising. A perfect time for planning and creativity.',
        };
      case CyclePhase.ovulation:
        return {
          'title': 'Radiant Energy',
          'content':
              'You are at your peak. Connect with others and embrace your glow.',
        };
      case CyclePhase.luteal:
        return {
          'title': 'Inner Focus',
          'content':
              'Slow down and listen to your thoughts. Nature walks might help today.',
        };
    }
  } else {
    // Role: Him
    final partnerEntries = await ref.watch(partnerCycleEntriesProvider.future);
    if (partnerEntries.isEmpty) {
      return {
        'title': 'Relationship Hub',
        'content':
            'Once she starts tracking, you will see how to best support her here.',
      };
    }
    final phase = CycleCalculator.calculate(partnerEntries).phase;

    switch (phase) {
      case CyclePhase.menstrual:
        return {
          'title': 'Be Her Comfort',
          'content':
              'She might need extra rest. Small gestures like tea or her favorite snack go a long way.',
        };
      case CyclePhase.follicular:
        return {
          'title': 'Plan Something Fun',
          'content':
              'Her energy is returning. Why not suggest a date or a light activity together?',
        };
      case CyclePhase.ovulation:
        return {
          'title': 'Adore Her',
          'content':
              'She is likely feeling confident and social. Celebrate her presence today.',
        };
      case CyclePhase.luteal:
        return {
          'title': 'Patient Presence',
          'content':
              'She might be more sensitive now. Be a calm and steady listener for her.',
        };
    }
  }

  return {
    'title': 'Daily Focus',
    'content': 'A gentle reminder to take care of each other today.',
  };
}
