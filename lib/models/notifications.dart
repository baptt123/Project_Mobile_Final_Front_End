class Notifications {
  final String id;
  final String idUser;
  final String action;

  Notifications({required this.id, required this.idUser, required this.action});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'] ?? '',
      idUser: json['idUser'] ?? '',
      action: json['action'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'idUser': idUser,
    };
  }
}
