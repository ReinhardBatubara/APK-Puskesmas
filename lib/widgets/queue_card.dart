import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/queue_model.dart';
import '../core/utils/date_helper.dart';

class QueueCard extends StatelessWidget {
  final QueueModel queue;
  final VoidCallback? onTap;
  final bool showActions;
  final Function(String)? onStatusChange;

  const QueueCard({
    super.key,
    required this.queue,
    this.onTap,
    this.showActions = false,
    this.onStatusChange,
  });

  Color _statusColor(String status) {
    switch (status) {
      case QueueStatus.waiting:
        return Colors.orange;
      case QueueStatus.called:
        return Colors.blue;
      case QueueStatus.serving:
        return const Color(0xFF2E7D32);
      case QueueStatus.done:
        return Colors.grey;
      case QueueStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case QueueStatus.waiting:
        return Icons.hourglass_empty;
      case QueueStatus.called:
        return Icons.notifications_active;
      case QueueStatus.serving:
        return Icons.medical_services;
      case QueueStatus.done:
        return Icons.check_circle;
      case QueueStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(queue.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      queue.queueNumber,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          queue.patientName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          queue.serviceName,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon(queue.status), size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          queue.status,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey.withOpacity(0.15), height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.badge_outlined, size: 13, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    queue.patientType,
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 13, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    DateHelper.timeAgo(queue.createdAt),
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (queue.complaint != null && queue.complaint!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  queue.complaint!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (showActions && onStatusChange != null) ...[
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: QueueStatus.all
                        .where((s) => s != queue.status)
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: OutlinedButton(
                                onPressed: () => onStatusChange!(s),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _statusColor(s),
                                  side: BorderSide(color: _statusColor(s)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(s,
                                    style: GoogleFonts.poppins(fontSize: 11)),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
