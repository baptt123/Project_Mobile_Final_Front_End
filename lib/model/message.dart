class Messages {
  final int id;
  final String message;
  final DateTime sendingDate;
  final int idSender;
  final int idReceipt;

  Messages({
    required this.id,
    required this.message,
    required this.sendingDate,
    required this.idSender,
    required this.idReceipt,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      id: json['id'],
      message: json['message'],
      sendingDate: DateTime.parse(json['sendingDate']), // Parse chuỗi ISO 8601
      idSender: json['idSender'],
      idReceipt: json['idReceipt'],
    );
  }


  // Chuyển đổi đối tượng Messages thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sendingDate': sendingDate.toIso8601String(),
      'idSender': idSender,
      'idReceipt': idReceipt,
    };
  }
}
