// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profissional.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfissionalAdapter extends TypeAdapter<Profissional> {
  @override
  final int typeId = 1;

  @override
  Profissional read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profissional(
      id: fields[0] as int,
      barbeariaId: fields[1] as int,
      nome: fields[2] as String,
      especialidade: fields[3] as String,
      disponibilidade: fields[4] as String,
      rating: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Profissional obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.barbeariaId)
      ..writeByte(2)
      ..write(obj.nome)
      ..writeByte(3)
      ..write(obj.especialidade)
      ..writeByte(4)
      ..write(obj.disponibilidade)
      ..writeByte(5)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfissionalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
