import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String description;
  @HiveField(4)
  final String userId;

  Expense({required this.id, required this.amount, required this.date, required this.description, required this.userId});
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    final id = reader.readString();
    final amount = reader.readDouble();
    final date = reader.read();
    final description = reader.readString();
    final userId = reader.readString();
    return Expense(
      id: id,
      amount: amount,
      date: date,
      description: description,
      userId: userId,
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer.writeString(obj.id);
    writer.writeDouble(obj.amount);
    writer.write(obj.date);
    writer.writeString(obj.description);
    writer.writeString(obj.userId);
  }
}
