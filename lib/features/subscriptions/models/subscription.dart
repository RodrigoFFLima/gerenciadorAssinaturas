import 'package:flutter/material.dart';

class Subscription {
  const Subscription({
    required this.name,
    required this.category,
    required this.provider,
    required this.cycle,
    required this.price,
    required this.nextBillingDate,
    required this.status,
    required this.accentColor,
    required this.cardAlias,
    required this.description,
  });

  final String name;
  final String category;
  final String provider;
  final String cycle;
  final double price;
  final String nextBillingDate;
  final String status;
  final Color accentColor;
  final String cardAlias;
  final String description;
}
