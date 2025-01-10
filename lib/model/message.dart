import 'dart:convert';

class Message {
  int? _id;
  String? _message;
  DateTime _sendingDate;
  int? _idsender;
  int? _idReceipt;

  Message(this._id, this._message, this._sendingDate, this._idsender, this._idReceipt);

  int get idReceipt => _idReceipt!;
  set idReceipt(int value) {
    _idReceipt = value;
  }

  int get idsender => _idsender!;
  set idsender(int value) {
    _idsender = value;
  }

  DateTime get sendingDate => _sendingDate;
  set sendingDate(DateTime value) {
    _sendingDate = value;
  }

  String get message => _message!;
  set message(String value) {
    _message = value;
  }

  int get id => _id!;
  set id(int value) {
    _id = value;
  }

  // chuyen doi Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'message': _message,
      'sendingDate': _sendingDate.toIso8601String(), // Convert DateTime to String
      'idSender': _idsender,
      'idReceipt': _idReceipt,
    };
  }

  // chuyen doi JSON sang Object
  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      json['id'],
      json['message'],
      DateTime.parse(json['sendingDate']), // Convert String to DateTime
      json['idsender'],
      json['idReceipt'],
    );
  }
}


