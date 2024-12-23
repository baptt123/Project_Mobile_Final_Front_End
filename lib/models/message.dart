import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class Messages {
  final String id;
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
      sendingDate: DateTime.parse(json['sendingDate']),
      idSender: json['idSender'],
      idReceipt: json['idReceipt'],
    );
  }

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
