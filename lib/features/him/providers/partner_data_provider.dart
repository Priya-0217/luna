import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:her/features/auth/domain/app_user.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/cycle/domain/cycle_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'partner_data_provider.g.dart';

DateTime _parseDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return DateTime.now();
}

@riverpod
Stream<Map<String, dynamic>> partnerData(PartnerDataRef ref) {
  final auth = ref.watch(authProvider).value;
  final partnerUid = auth?.partnerUid;

  if (partnerUid == null) {
    return Stream.value({});
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(partnerUid)
      .snapshots()
      .map((doc) => doc.data() ?? {});
}

@riverpod
Stream<AppUser?> partnerProfile(PartnerProfileRef ref) {
  final auth = ref.watch(authProvider).value;
  final partnerUid = auth?.partnerUid;

  if (partnerUid == null) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(partnerUid)
      .snapshots()
      .map((doc) {
        final data = doc.data();
        if (data == null) return null;
        return AppUser.fromJson({
          ...data,
          'uid': partnerUid,
          'email': data['email'] ?? '',
        });
      });
}

@riverpod
Stream<List<CycleEntry>> partnerCycleEntries(PartnerCycleEntriesRef ref) {
  final auth = ref.watch(authProvider).value;
  final partnerUid = auth?.partnerUid;

  if (partnerUid == null) {
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(partnerUid)
      .collection('cycle_entries')
      .orderBy('date', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          final dateVal = _parseDate(data['startDate'] ?? data['date']);
          final endDateVal = data['endDate'] != null ? _parseDate(data['endDate']) : (data['isPeriodEnd'] == true ? dateVal : null);
          return CycleEntry(
            id: data['id'] ?? doc.id,
            userId: partnerUid,
            startDate: dateVal,
            endDate: endDateVal,
            createdAt: _parseDate(data['createdAt'] ?? data['date'] ?? data['startDate']),
            synced: true,
          );
        }).toList(),
      );
}
