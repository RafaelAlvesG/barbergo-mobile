import 'package:hive/hive.dart';

part 'profissional.g.dart';

@HiveType(typeId: 1)
class Profissional extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int barbeariaId;
  @HiveField(2)
  final String nome;
  @HiveField(3)
  final String especialidade;
  @HiveField(4)
  final String disponibilidade; // 'hoje','amanha','indisponivel'
  @HiveField(5)
  final double rating;

  Profissional({
    required this.id,
    required this.barbeariaId,
    required this.nome,
    required this.especialidade,
    required this.disponibilidade,
    required this.rating,
  });
}
