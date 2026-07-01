// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funcionario.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FuncionarioAdapter extends TypeAdapter<Funcionario> {
  @override
  final int typeId = 3;

  @override
  Funcionario read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Funcionario(
      nome: fields[0] as String,
      email: fields[1] as String,
      senha: fields[2] as String,
      telefone: fields[3] as String,
      barbeariaId: fields[4] as int,
      cargo: fields[5] as String,
      notificacoesAtivas: fields[6] as bool,
      modoEscuro: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Funcionario obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.senha)
      ..writeByte(3)
      ..write(obj.telefone)
      ..writeByte(4)
      ..write(obj.barbeariaId)
      ..writeByte(5)
      ..write(obj.cargo)
      ..writeByte(6)
      ..write(obj.notificacoesAtivas)
      ..writeByte(7)
      ..write(obj.modoEscuro);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuncionarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
