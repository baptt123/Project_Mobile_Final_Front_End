import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class Messages {
  final String id;
  final String message;
  final DateTime sendingDate;
  final String userNameSender;
  final String userNameReceiver;

  Messages({
    required this.id,
    required this.message,
    required this.sendingDate,
    required this.userNameSender,
    required this.userNameReceiver
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sendingDate': sendingDate.toIso8601String(),
      'userNameSender': userNameSender,
      'userNameReceiver': userNameReceiver,
    };
  }

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      sendingDate: json['sendingDate'] != null
          ? DateTime.parse(json['sendingDate'])
          : DateTime.now(),
      userNameSender: json['userNameSender'] ?? '',
      userNameReceiver: json['userNameReceiver'] ?? '',
    );
  }
}
