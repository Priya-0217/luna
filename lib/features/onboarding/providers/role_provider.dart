import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/role/app_role.dart';

final onboardingRoleProvider = StateProvider<AppRole>((ref) => AppRole.unknown);
