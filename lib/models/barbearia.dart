import 'package:hive/hive.dart';

part 'barbearia.g.dart';

@HiveType(typeId: 0)
class Barbearia extends HiveObject {
  @HiveField(0) int id;
  @HiveField(1) String nome;
  @HiveField(2) String endereco;
  @HiveField(3) String distancia;
  @HiveField(4) double rating;
  @HiveField(5) bool aberta;
  @HiveField(6) List<int> diasTrabalho; 

  Barbearia({
    required this.id,
    required this.nome,
    this.endereco = "Endereço não informado",
    this.distancia = "0 km",
    this.rating = 5.0,
    this.aberta = true,
    this.diasTrabalho = const [1, 2, 3, 4, 5, 6],
  });
}
