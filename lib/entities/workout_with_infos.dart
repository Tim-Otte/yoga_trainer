import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/all.dart';

class WorkoutWithInfos {
  const WorkoutWithInfos({
    required this.workout,
    required this.duration,
    required this.difficulty,
  });

  final Workout workout;
  final int duration;
  final Difficulty difficulty;
}
