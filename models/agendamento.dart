import 'package:hive/hive.dart';

part 'agendamento.g.dart';

@HiveType(typeId: 2)
class Agendamento extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String clienteNome;
  @HiveField(2)
  final String servico;
  @HiveField(3)
  final int duracao;
  @HiveField(4)
  final double preco;
  @HiveField(5)
  final String barbeiroNome;
  @HiveField(6)
  final String barbeariaNome;
  @HiveField(7)
  final DateTime dataHora;
  @HiveField(8)
  final String status; // 'confirmado','aguardando','finalizado'
  @HiveField(9)
  final String observacoes;

  Agendamento({
    required this.id,
    required this.clienteNome,
    required this.servico,
    required this.duracao,
    required this.preco,
    required this.barbeiroNome,
    required this.barbeariaNome,
    required this.dataHora,
    required this.status,
    required this.observacoes,
  });
}
