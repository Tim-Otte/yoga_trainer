import 'package:drift/drift.dart';
import 'package:yoga_trainer/entities/poses.dart';
import 'package:yoga_trainer/entities/workouts.dart';

class WorkoutPoses extends Table {
  IntColumn get workout => integer().references(Workouts, #id)();
  IntColumn get pose => integer().references(Poses, #id)();
}
