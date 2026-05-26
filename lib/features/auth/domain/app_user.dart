import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    required String displayName,
    String? partnerUid,
    String? coupleId,
    @Default(false) bool isLinked,
    @Default(28) int cycleAverageLength,
    @Default(5) int periodAverageLength,
    @Default(false) bool isOnboarded,
    String? role,
    String? myLoveCode,
    String? partnerRole,
    String? partnerDisplayName,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
