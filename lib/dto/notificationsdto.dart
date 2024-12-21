class NotificationsDTO {

  final String action;

  NotificationsDTO({
    required this.action,
  });

  // Convert from JSON
  factory NotificationsDTO.fromJson(Map<String, dynamic> json) {
    return NotificationsDTO(
      action: json['action'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'action': action,
    };
  }
}