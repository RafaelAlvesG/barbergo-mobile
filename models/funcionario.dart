import 'package:hive/hive.dart';

part 'funcionario.g.dart';

@HiveType(typeId: 3)
class Funcionario extends HiveObject {
  @HiveField(0) final String nome;
  @HiveField(1) final String email;
  @HiveField(2) final String senha;
  @HiveField(3) final String telefone;
  @HiveField(4) final int barbeariaId;
  @HiveField(5) final String cargo;
  @HiveField(6) final bool notificacoesAtivas;
  @HiveField(7) final bool modoEscuro;

  Funcionario({
    required this.nome,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.barbeariaId,
    this.cargo = "Barbeiro",
    this.notificacoesAtivas = true,
    this.modoEscuro = false,
  });
}
