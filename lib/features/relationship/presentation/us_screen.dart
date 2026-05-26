import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/relationship/data/relationship_repository.dart';
import 'package:her/features/relationship/data/memory_service.dart';
import 'package:her/features/relationship/domain/memory.dart';
import 'package:her/features/relationship/domain/bucket_item.dart';
import 'package:her/features/relationship/presentation/widgets/anniversary_counter.dart';

class UsScreen extends ConsumerStatefulWidget {
  const UsScreen({super.key});

  @override
  ConsumerState<UsScreen> createState() => _UsScreenState();
}

class _UsScreenState extends ConsumerState<UsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.softIvory,
      appBar: AppBar(
        title: Text('Us', style: AppTypography.h3),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.rosePrimary,
          labelColor: AppColors.rosePrimary,
          unselectedLabelColor: isDark ? AppColors.warmGray500 : AppColors.warmGray400,
          tabs: const [
            Tab(text: 'Memories'),
            Tab(text: 'Bucket List'),
          ],
        ),
      ),
      body: Column(
        children: [
          const AnniversaryCounter(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const _MemoriesTab(),
                const _BucketListTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleFabPressed(),
        backgroundColor: AppColors.rosePrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _handleFabPressed() {
    if (_tabController.index == 0) {
      _showAddMemoryDialog();
    } else {
      _showAddBucketItemDialog();
    }
  }

  void _showAddMemoryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddMemorySheet(),
    );
  }

  void _showAddBucketItemDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AddBucketItemDialog(),
    );
  }
}

class _AddMemorySheet extends ConsumerStatefulWidget {
  const _AddMemorySheet();

  @override
  ConsumerState<_AddMemorySheet> createState() => _AddMemorySheetState();
}

class _AddMemorySheetState extends ConsumerState<_AddMemorySheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _save() async {
    if (_titleController.text.isEmpty || _imageFile == null) return;

    setState(() => _isLoading = true);
    try {
      final auth = ref.read(authProvider).value;
      if (auth?.coupleId != null && auth?.uid != null) {
        await ref.read(memoryServiceProvider).createMemory(
          coupleId: auth!.coupleId!,
          title: _titleController.text,
          description: _descController.text,
          imageFile: _imageFile!,
          userId: auth.uid,
        );
        if (mounted) Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("New Memory", style: AppTypography.h4),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.warmGray100,
                borderRadius: BorderRadius.circular(20),
                image: _imageFile != null ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover) : null,
              ),
              child: _imageFile == null ? const Icon(Icons.add_a_photo_outlined, size: 40, color: AppColors.warmGray400) : null,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Memory Title", hintText: "e.g., That rainy day in Paris"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(labelText: "Description (Optional)"),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rosePrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Save Memory"),
          ),
        ],
      ),
    );
  }
}

class _AddBucketItemDialog extends ConsumerStatefulWidget {
  const _AddBucketItemDialog();
  @override
  ConsumerState<_AddBucketItemDialog> createState() => _AddBucketItemDialogState();
}

class _AddBucketItemDialogState extends ConsumerState<_AddBucketItemDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Bucket Item"),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: "e.g., Skydiving together"),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        TextButton(
          onPressed: () async {
            if (_controller.text.isNotEmpty) {
              final auth = ref.read(authProvider).value;
              if (auth?.coupleId != null) {
                await ref.read(relationshipRepositoryProvider).addBucketItem(auth!.coupleId!, _controller.text);
                if (mounted) Navigator.pop(context);
              }
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

class _MemoriesTab extends ConsumerWidget {
  const _MemoriesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider).value;
    final coupleId = auth?.coupleId;

    if (coupleId == null) return const Center(child: Text("Link your partner to start memories"));

    final memoriesStream = ref.watch(relationshipRepositoryProvider).watchMemories(coupleId);

    return StreamBuilder<List<Memory>>(
      stream: memoriesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No memories yet. Add your first one!"));
        }

        final memories = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: memories.length,
          itemBuilder: (context, index) {
            final memory = memories[index];
            return _MemoryCard(memory: memory);
          },
        );
      },
    );
  }
}

class _MemoryCard extends StatelessWidget {
  final Memory memory;
  const _MemoryCard({required this.memory});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              memory.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 250,
                color: AppColors.warmGray200,
                child: const Icon(Icons.broken_image, size: 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(memory.title, style: AppTypography.h4),
                if (memory.description != null && memory.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(memory.description!, style: AppTypography.bodyMedium),
                ],
                const SizedBox(height: 12),
                Text(
                  "Added on ${memory.createdAt.day}/${memory.createdAt.month}/${memory.createdAt.year}",
                  style: AppTypography.bodySmall.copyWith(color: AppColors.warmGray500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BucketListTab extends ConsumerWidget {
  const _BucketListTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider).value;
    final coupleId = auth?.coupleId;

    if (coupleId == null) return const Center(child: Text("Link your partner to start a bucket list"));

    final bucketStream = ref.watch(relationshipRepositoryProvider).watchBucketList(coupleId);

    return StreamBuilder<List<BucketItem>>(
      stream: bucketStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Your bucket list is empty. Dream big!"));
        }

        final items = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSurface : AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: CheckboxListTile(
                title: Text(
                  item.title,
                  style: AppTypography.bodyLarge.copyWith(
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                    color: item.isCompleted ? AppColors.warmGray400 : null,
                  ),
                ),
                value: item.isCompleted,
                activeColor: AppColors.rosePrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onChanged: (val) {
                  if (item.id != null) {
                    ref.read(relationshipRepositoryProvider).toggleBucketItem(coupleId, item.id!, val ?? false);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
