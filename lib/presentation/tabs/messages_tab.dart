import 'package:flutter/material.dart';

import '../design/tokens.dart';
import '../models/chat_models.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({
    super.key,
    required this.threads,
    required this.onOpenThread,
  });

  final List<ChatThread> threads;
  final ValueChanged<ChatThread> onOpenThread;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Messages', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Expanded(
          child: threads.isEmpty
              ? const Center(child: Text('No chats yet.'))
              : ListView.separated(
                  itemCount: threads.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (BuildContext context, int index) {
                    final ChatThread thread = threads[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onOpenThread(thread),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: BlueTalkColors.borderWarm),
                          color: BlueTalkColors.cardOverlay,
                        ),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: thread.isActive
                                  ? const Color(0xFF7A9A78)
                                  : const Color(0xFF9F8C6E),
                              child: Text(thread.name.substring(0, 1)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    thread.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: BlueTalkColors.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    thread.preview,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF5A6C5E),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (thread.isActive)
                              const Icon(Icons.circle,
                                  size: 14, color: BlueTalkColors.primaryText),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
