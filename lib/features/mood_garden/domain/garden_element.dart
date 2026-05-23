import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';

enum FlowerType {
  rose,
  daisy,
  tulip,
  sunflower,
  lavender,
  cherry;

  String get emoji => switch (this) {
        FlowerType.rose => '🌹',
        FlowerType.daisy => '🌼',
        FlowerType.tulip => '🌷',
        FlowerType.sunflower => '🌻',
        FlowerType.lavender => '💜',
        FlowerType.cherry => '🌸',
      };

  Color get color => switch (this) {
        FlowerType.rose => AppColors.roseDeep,
        FlowerType.daisy => AppColors.goldPrimary,
        FlowerType.tulip => AppColors.rosePrimary,
        FlowerType.sunflower => AppColors.goldMid,
        FlowerType.lavender => AppColors.mauvePrimary,
        FlowerType.cherry => AppColors.roseSoft,
      };
}

enum GardenWeather {
  sunny,
  cloudy,
  rainy,
  golden;

  String get emoji => switch (this) {
        GardenWeather.sunny => '☀️',
        GardenWeather.cloudy => '☁️',
        GardenWeather.rainy => '🌧️',
        GardenWeather.golden => '🌅',
      };
}

enum GrowthStage { seed, sprout, bloom, fullBloom }
