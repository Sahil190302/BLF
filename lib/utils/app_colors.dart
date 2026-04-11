import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const primary = Color(0xFF2B4B40); // Modern Indigo
  static const primaryshipcart = Color(0xFF1a6161); // Modern Indigo
  static const primaryColor = Color(0xFF6366F1);
  static const primaryLight = Color(0xFF818CF8);
  static const primaryDark = Color(0xFF025e53);

  static const splashGreen = Color(0xFF2E7D32); // splash green
  static const splashGreenLight = Color(0xFF66BB6A);

  // Secondary & Accent Colors
  static const secondary = Color(0xFF10B981); // Emerald Green
  static const secondaryColor = Color(0xFF10B981);
  static const accent = Color(0xFFF59E0B); // Amber
  static const accentLight = Color(0xFFFBBF24);

  // Background Colors
  static const background = Color(0xFFFAFAFA); // Off-white
  static const backgroundLight = Color(0xFFFFFFFF);
  static const backgroundDark = Color(0xFFF5F5F5);
  static const scaffold = Color(0xFFFAFAFA);

  // Text Colors
  static const textPrimary = Color(0xFF1F2937); // Dark Gray
  static const textSecondary = Color(0xFF6B7280); // Medium Gray
  static const textTertiary = Color(0xFF9CA3AF); // Light Gray
  static const textDark = Color(0xFF111827);
  static const textLight = Color(0xFF6B7280);
  static const textBlack = Color(0xFF000000);
  static const hint = Color(0xFFD1D5DB);

  // Neutral Colors
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const darkGrey = Color(0xFF374151);
  static const lightGrey = Color(0xFF9CA3AF);

  // Status Colors
  static const success = Color(0xFF10B981); // Emerald
  static const green = Color(0xFF10B981);
  static const darkgreen = Color(0xFF2da879);
  static const error = Color(0xFFEF4444); // Red
  static const red = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B); // Amber
  static const info = Color(0xFF3B82F6); // Blue
  static const blueAccent = Color(0xFF3B82F6);

  // Button Colors
  static const button = Color(0xFF6366F1);
  static const buttonText = Color(0xFFFFFFFF);
  static const buttonDisabled = Color(0xFFE5E7EB);
  static const buttonHover = Color(0xFF4F46E5);

  // Border & Divider Colors
  static const border = Color(0xFFE5E7EB);
  static const borderLight = Color(0xFFF3F4F6);
  static const borderDark = Color(0xFFD1D5DB);
  static const divider = Color(0xFFE5E7EB);

  // Card & Surface Colors
  static const cardBackground = Color(0xFFFFFFFF);
  static const cardShadow = Color(0x1A000000);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFFAFAFA);

  // Gradient Colors
  static const gradientStart = Color(0xFF6366F1);
  static const gradientEnd = Color(0xFF8B5CF6);

  // Common Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static const shadow = Color(0x0D000000); // 5% opacity
  static const shadowMedium = Color(0x1A000000); // 10% opacity
  static const shadowDark = Color(0x33000000); // 20% opacity

  // Overlay Colors
  static const overlayLight = Color(0x0DFFFFFF); // 5% white
  static const overlayMedium = Color(0x1AFFFFFF); // 10% white
  static const overlayDark = Color(0x80000000); // 50% black

  // Special Colors
  static const premium = Color(0xFFEAB308); // Gold
  static const featured = Color(0xFF8B5CF6); // Purple
  static const trending = Color(0xFFEC4899); // Pink
}
