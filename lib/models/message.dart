import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class Messages {
  final String id;
  final String message;
  final DateTime sendingDate;
  final String fullNameSender;
  final String fullNameReceiver;

  Messages({
    required this.id,
    required this.message,
    required this.sendingDate,
    required this.fullNameSender,
    required this.fullNameReceiver
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sendingDate': sendingDate.toIso8601String(),
      'fullNameSender': fullNameSender,
      'fullNameReceiver': fullNameReceiver,
    };
  }

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      sendingDate: json['sendingDate'] != null
          ? DateTime.parse(json['sendingDate'])
          : DateTime.now(),
      fullNameSender: json['userNameSender'] ?? '',
      fullNameReceiver: json['userNameReceiver'] ?? '',
    );
  }
}
