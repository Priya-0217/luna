import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/widgets/status_views.dart';

extension AsyncValueUI<T> on AsyncValue<T> {
  Widget whenWidget({
    required Widget Function(T data) data,
    String? loadingMessage,
    Widget Function(Object error, StackTrace stackTrace)? error,
    bool skipLoadingOnReload = false,
  }) {
    return when(
      skipLoadingOnRefresh: skipLoadingOnReload,
      data: data,
      error: error ?? (err, stack) => ErrorView(message: err.toString()),
      loading: () => LoadingView(message: loadingMessage),
    );
  }

  void showSnackBarOnError(BuildContext context) {
    if (!isLoading && hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
