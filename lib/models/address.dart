import 'package:flutter/material.dart';

class Address {
  String fullName;
  String phoneNumber;
  String addressLine1;
  String addressLine2;
  String city;
  String pincode;
  String landmark;
  bool isDefault;

  Address({
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.pincode,
    this.landmark = '',
    this.isDefault = false,
  });
}