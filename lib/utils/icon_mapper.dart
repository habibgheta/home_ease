import 'package:flutter/material.dart';

class IconMapper {
  static IconData getIcon(String iconName) {
    switch (iconName) {
      case "electrical_services":
        return Icons.electrical_services;

      case "plumbing":
        return Icons.plumbing;

      case "handyman":
        return Icons.handyman;

      case "format_paint":
        return Icons.format_paint;

      case "cleaning_services":
        return Icons.cleaning_services;

      default:
        return Icons.home_repair_service;
    }
  }
}
