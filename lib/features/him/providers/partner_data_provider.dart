import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
    debugPrint(
      '🤝 PartnerDataProvider: No partnerUid found, returning empty stream',
    );
    return Stream.value({});
  }

  debugPrint(
    '🤝 PartnerDataProvider: Listening for partner data changes: $partnerUid',
  );
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

  debugPrint(
    '🤝 PartnerDataProvider: Fetching partner profile for $partnerUid',
  );
  return FirebaseFirestore.instance
      .collection('users')
      .doc(partnerUid)
      .snapshots()
      .map((doc) {
        final data = doc.data();
        if (data == null) return null;
        debugPrint(
          '🤝 PartnerDataProvider: Partner profile updated: ${data['displayName']}',
        );
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

  debugPrint(
    '🤝 PartnerDataProvider: Streaming partner cycle entries for $partnerUid',
  );
  return FirebaseFirestore.instance
      .collection('users')
      .doc(partnerUid)
      .collection(
        'cycleEntries',
      ) // 🚨 FIXED collection name to match FirestoreService
      .orderBy('startDate', descending: true) // Using startDate as primary sort
      .snapshots()
      .handleError((error) {
        debugPrint(
          '⚠️ PartnerDataProvider: Firestore error on cycleEntries: $error',
        );
        // Return an empty stream or rethrow based on preference
        // Rethrowing allows AsyncValue to catch it, but we've logged it nicely.
        throw error;
      })
      .map((snapshot) {
        debugPrint(
          '🤝 PartnerDataProvider: Found ${snapshot.docs.length} partner cycle documents',
        );
        return snapshot.docs.map((doc) {
          final data = doc.data();
          // Fallback through common date field names
          final dateVal = _parseDate(
            data['startDate'] ?? data['date'] ?? data['createdAt'],
          );
          final endDateVal = data['endDate'] != null
              ? _parseDate(data['endDate'])
              : (data['isPeriodEnd'] == true ? dateVal : null);
          return CycleEntry(
            id: data['id'] ?? doc.id,
            userId: partnerUid,
            startDate: dateVal,
            endDate: endDateVal,
            createdAt: _parseDate(
              data['createdAt'] ?? data['date'] ?? data['startDate'],
            ),
            synced: true,
          );
        }).toList();
      });
}
