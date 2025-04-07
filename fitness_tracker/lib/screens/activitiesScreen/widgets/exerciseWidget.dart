import 'package:flutter/material.dart';

class ExerciseData {
  final String title;
  final String subTitle;
  final int sets;
  final int minutes;
  final int kcal;

  ExerciseData({
    required this.title,
    required this.subTitle,
    required this.sets,
    required this.minutes,
    required this.kcal,
  });
}

class ConfigExerciseData {
  
  final Map<String, ExerciseData> exerciseData = {
    'Bicep': ExerciseData(
      title: 'Bicep',
      subTitle: 'Improve your Bicep',
      sets: 3,
      minutes: 35,
      kcal: 452,
    ),
    'Body-Back': ExerciseData(
      title: 'Body-Back',
      subTitle: 'Improve your Body Back',
      sets: 3,
      minutes: 40,
      kcal: 480,
    ),
    'Body Butt': ExerciseData(
      title: 'Body Butt',
      subTitle: 'Improve your Body Butt',
      sets: 4,
      minutes: 45,
      kcal: 500,
    ),
    'Legs and core': ExerciseData(
      title: 'Legs and core',
      subTitle: 'Improve legs and core',
      sets: 3,
      minutes: 30,
      kcal: 400,
    ),
    'Pectoral Machine': ExerciseData(
      title: 'Pectoral Machine',
      subTitle: 'Improve your pectoral machine skills and attributes',
      sets: 3,
      minutes: 35,
      kcal: 420,
    ),
    'Weight Loss': ExerciseData(
      title: 'Weight Loss',
      subTitle: 'This will helpful for your loss weight journey',
      sets: 4,
      minutes: 50,
      kcal: 600,
    ),
    'Woman up front': ExerciseData(
      title: 'Woman up front',
      subTitle: 'This will helpful for your up front journey',
      sets: 3,
      minutes: 40,
      kcal: 450,
    ),
  };
}