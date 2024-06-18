import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Loader extends ConsumerWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: SizedBox(
        width: 35,
        height: 35,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
