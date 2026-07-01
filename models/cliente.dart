import 'package:hive/hive.dart';

part 'cliente.g.dart';

@HiveType(typeId: 4)
class Cliente extends HiveObject {
  @HiveField(0) final String nome;
  @HiveField(1) final String email;
  @HiveField(2) final String senha;

  Cliente({
    required this.nome,
    required this.email,
    required this.senha,
  });
}
