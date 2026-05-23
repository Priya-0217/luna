import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';

enum Mood {
  joyful,
  calm,
  tired,
  anxious,
  sad,
  irritable,
  excited,
  grateful,
  content,
  cozy,
  crying,
  stressed;

  String get label => switch (this) {
        Mood.joyful => 'Joyful',
        Mood.calm => 'Calm',
        Mood.tired => 'Tired',
        Mood.anxious => 'Anxious',
        Mood.sad => 'Sad',
        Mood.irritable => 'Irritable',
        Mood.excited => 'Excited',
        Mood.grateful => 'Grateful',
        Mood.content => 'Content',
        Mood.cozy => 'Cozy',
        Mood.crying => 'Crying',
        Mood.stressed => 'Stressed',
      };

  String get emoji => switch (this) {
        Mood.joyful => '🌟',
        Mood.calm => '🌿',
        Mood.tired => '😴',
        Mood.anxious => '💨',
        Mood.sad => '🌧️',
        Mood.irritable => '🌪️',
        Mood.excited => '✨',
        Mood.grateful => '🙏',
        Mood.content => '🌸',
        Mood.cozy => '☕',
        Mood.crying => '💧',
        Mood.stressed => '😣',
      };

  Color get color => switch (this) {
        Mood.joyful => AppColors.goldPrimary,
        Mood.calm => const Color(0xFF6DBF8A),
        Mood.tired => AppColors.warmGray400,
        Mood.anxious => AppColors.mauveMid,
        Mood.sad => AppColors.info,
        Mood.irritable => AppColors.warning,
        Mood.excited => AppColors.rosePrimary,
        Mood.grateful => AppColors.goldMid,
        Mood.content => AppColors.roseSoft,
        Mood.cozy => AppColors.goldSoft,
        Mood.crying => const Color(0xFF6BB8FF),
        Mood.stressed => AppColors.error,
      };

  String get illustrationKey => switch (this) {
        Mood.joyful => 'char_happy',
        Mood.calm => 'char_peaceful',
        Mood.tired => 'char_tired',
        Mood.anxious => 'char_anxious',
        Mood.sad => 'char_sad',
        Mood.irritable => 'char_irritated',
        Mood.excited => 'char_excited',
        Mood.grateful => 'char_grateful',
        Mood.content => 'char_content',
        Mood.cozy => 'char_cozy',
        Mood.crying => 'char_crying',
        Mood.stressed => 'char_stressed',
      };
}
