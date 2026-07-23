/// Mirrors the `notifications` table.
enum NotificationType {
  tournamentStarting,
  roomRevealed,
  tournamentCompleted,
  tournamentCancelled,
  prizeCredited,
  orderFulfilled,
}

NotificationType _notificationTypeFromString(String value) {
  switch (value) {
    case 'tournament_starting':
      return NotificationType.tournamentStarting;
    case 'room_revealed':
      return NotificationType.roomRevealed;
    case 'tournament_completed':
      return NotificationType.tournamentCompleted;
    case 'tournament_cancelled':
      return NotificationType.tournamentCancelled;
    case 'prize_credited':
      return NotificationType.prizeCredited;
    case 'order_fulfilled':
      return NotificationType.orderFulfilled;
    default:
      throw ArgumentError('Unknown notification_type: $value');
  }
}

class AppNotification {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;

  /// tournament_id, order_id, etc. — used for deep-link routing
  final String? referenceId;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: _notificationTypeFromString(map['type'] as String),
      title: map['title'] as String,
      body: map['body'] as String,
      referenceId: map['reference_id'] as String?,
      isRead: map['is_read'] as bool,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Only used to mark as read — the only update Flutter is allowed
  /// to make per the RLS policy (insert happens server-side only).
  Map<String, dynamic> toMap() {
    return {
      'is_read': isRead,
    };
  }

  AppNotification copyWith({
    bool? isRead,
  }) {
    return AppNotification(
      id: id,
      userId: userId,
      type: type,
      title: title,
      body: body,
      referenceId: referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
