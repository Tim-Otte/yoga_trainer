import 'package:drift/drift.dart';
import 'package:yoga_trainer/entities/all.dart';

class WorkoutWeekdays extends Table {
  IntColumn get workout => integer().references(Workouts, #id)();
  IntColumn get weekday => intEnum<Weekday>()();

  @override
  Set<Column<Object>>? get primaryKey => {workout, weekday};
}
