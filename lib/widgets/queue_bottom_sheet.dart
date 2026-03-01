import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:twentyfour_player/providers/playback_provider.dart';

class QueueBottomSheet extends ConsumerWidget {
  const QueueBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playbackProvider);
    final controller = ref.read(playbackProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    // Use the engine's built-in display order to perfectly handle Shuffle mode
    final displayOrder = controller.getQueueDisplayOrder();
    final currentPos = controller.getCurrentDisplayQueuePosition(displayOrder: displayOrder);

    // Only show the songs that are playing NEXT
    final upcomingIndices = currentPos >= 0 && currentPos < displayOrder.length - 1
        ? displayOrder.sublist(currentPos + 1)
        : <int>[];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ─── Drag Handle & Title ───
            const SizedBox(height: 12),
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Up Next',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, indent: 24, endIndent: 24),

            // ─── The Queue List ───
            Expanded(
              child: upcomingIndices.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.queue_music_rounded, size: 48, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text(
                      'Queue is empty',
                      style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                itemCount: upcomingIndices.length,
                itemBuilder: (context, i) {
                  final actualIndex = upcomingIndices[i];
                  final item = state.queue[actualIndex];

                  return Dismissible(
                    key: ValueKey('queue_remove_${item.id}_$actualIndex'),
                    direction: DismissDirection.endToStart, // Swipe Left to delete
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      color: colorScheme.error.withOpacity(0.2),
                      child: Icon(Icons.delete_sweep_rounded, color: colorScheme.error),
                    ),
                    onDismissed: (_) {
                      controller.removeFromQueue(actualIndex);
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: item.coverUrl.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: item.coverUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          width: 48,
                          height: 48,
                          color: colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.music_note),
                        ),
                      ),
                      title: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        item.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        color: colorScheme.onSurfaceVariant,
                        onPressed: () => controller.removeFromQueue(actualIndex),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}