// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barbearia.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarbeariaAdapter extends TypeAdapter<Barbearia> {
  @override
  final int typeId = 0;

  @override
  Barbearia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Barbearia(
      id: fields[0] as int,
      nome: fields[1] as String,
      endereco: fields[2] as String,
      distancia: fields[3] as String,
      rating: fields[4] as double,
      aberta: fields[5] as bool,
      diasTrabalho: (fields[6] as List?)?.cast<int>() ?? const [1, 2, 3, 4, 5, 6],
    );
  }

  @override
  void write(BinaryWriter writer, Barbearia obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.endereco)
      ..writeByte(3)
      ..write(obj.distancia)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.aberta)
      ..writeByte(6)
      ..write(obj.diasTrabalho);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarbeariaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
