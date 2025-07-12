import 'package:drift/drift.dart';
import 'package:yoga_trainer/entities/body_parts.dart';

enum Difficulty { easy, medium, hard }

class Poses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withLength(max: 250)();
  IntColumn get duration => integer()(); // Duration in seconds
  IntColumn get difficulty => intEnum<Difficulty>()();
  IntColumn get affectedBodyPart => integer().references(BodyParts, #id)();
  TextColumn get imagePath => text().nullable()(); // Path to the image file
}
