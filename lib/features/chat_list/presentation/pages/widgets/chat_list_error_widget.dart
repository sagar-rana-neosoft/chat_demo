import 'package:flutter/material.dart';
import 'package:sagar_chat_demo/core/widgets/base_text.dart';

import '../../../../../core/constants/app_string_constants.dart';

class ChatListErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ChatListErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BaseText(
              AppStringConstants.chatLoadingError,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            BaseText(
              '${AppStringConstants.reason}: $message',
              color: Colors.grey,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: const BaseText(AppStringConstants.retry, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
