import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/relationship/data/relationship_repository.dart';
import 'package:her/features/relationship/domain/bucket_item.dart';

class BucketListScreen extends ConsumerWidget {
  const BucketListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;
    if (user?.coupleId == null)
      return const Scaffold(body: Center(child: Text('Not connected')));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Our Bucket List',
          style: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<BucketItem>>(
        stream: ref
            .watch(relationshipRepositoryProvider)
            .watchBucketList(user!.coupleId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CheckboxListTile(
                  title: Text(
                    item.title,
                    style: GoogleFonts.dmSans(
                      decoration: item.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: item.isCompleted
                          ? AppColors.warmGray400
                          : AppColors.darkText,
                    ),
                  ),
                  value: item.isCompleted,
                  onChanged: (val) {
                    if (item.id != null) {
                      ref
                          .read(relationshipRepositoryProvider)
                          .toggleBucketItem(
                            user.coupleId!,
                            item.id!,
                            val ?? false,
                          );
                    }
                  },
                  activeColor: AppColors.rosePrimary,
                  checkColor: Colors.white,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addBucketItem(context, ref, user.coupleId!),
        backgroundColor: AppColors.rosePrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addBucketItem(BuildContext context, WidgetRef ref, String coupleId) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Bucket List'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g., Trip to Paris'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(relationshipRepositoryProvider)
                    .addBucketItem(coupleId, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
