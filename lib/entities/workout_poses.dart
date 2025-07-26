import 'package:drift/drift.dart';
import 'package:yoga_trainer/entities/all.dart';

class WorkoutPoses extends Table {
  IntColumn get workout => integer().references(Workouts, #id)();
  IntColumn get pose => integer().references(Poses, #id)();
  IntColumn get order => integer()();
  IntColumn get side => intEnum<Side>().nullable()();
  IntColumn get prepTime => integer().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {workout, pose, order};
}
