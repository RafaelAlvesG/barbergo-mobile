// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agendamento.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgendamentoAdapter extends TypeAdapter<Agendamento> {
  @override
  final int typeId = 2;

  @override
  Agendamento read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Agendamento(
      id: fields[0] as String,
      clienteNome: fields[1] as String,
      servico: fields[2] as String,
      duracao: fields[3] as int,
      preco: fields[4] as double,
      barbeiroNome: fields[5] as String,
      barbeariaNome: fields[6] as String,
      dataHora: fields[7] as DateTime,
      status: fields[8] as String,
      observacoes: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Agendamento obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clienteNome)
      ..writeByte(2)
      ..write(obj.servico)
      ..writeByte(3)
      ..write(obj.duracao)
      ..writeByte(4)
      ..write(obj.preco)
      ..writeByte(5)
      ..write(obj.barbeiroNome)
      ..writeByte(6)
      ..write(obj.barbeariaNome)
      ..writeByte(7)
      ..write(obj.dataHora)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.observacoes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgendamentoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
