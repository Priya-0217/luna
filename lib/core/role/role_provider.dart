import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/core/role/app_role.dart';
import 'package:her/features/auth/providers/auth_provider.dart';

part 'role_provider.g.dart';

@riverpod
AppRole currentRole(CurrentRoleRef ref) {
  final authState = ref.watch(authProvider);

  return authState.maybeWhen(
    data: (user) {
      if (user == null) return AppRole.unknown;
      if (user.role == 'him') return AppRole.him;
      if (user.role == 'her') return AppRole.her;
      return AppRole.unknown;
    },
    orElse: () => AppRole.unknown,
  );
}
