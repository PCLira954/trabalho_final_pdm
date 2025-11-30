// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactHiveAdapter extends TypeAdapter<ContactHive> {
  @override
  final int typeId = 1;

  @override
  ContactHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactHive(
      id: fields[0] as String,
      name: fields[1] as String,
      phone: fields[2] as String,
      email: fields[3] as String?,
      latitude: fields[4] as double?,
      longitude: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ContactHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
