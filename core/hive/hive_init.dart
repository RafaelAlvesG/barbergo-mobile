import 'package:hive_flutter/hive_flutter.dart';
import '../../models/barbearia.dart';
import '../../models/profissional.dart';
import '../../models/agendamento.dart';
import '../../models/funcionario.dart';
import '../../models/cliente.dart';
import 'boxes.dart';

class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Registro de Adaptadores
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(BarbeariaAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ProfissionalAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(AgendamentoAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(FuncionarioAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(ClienteAdapter());

    // Abertura de Caixas
    await Hive.openBox<Barbearia>(AppBoxes.barbearias);
    await Hive.openBox<Profissional>(AppBoxes.profissionais);
    await Hive.openBox<Agendamento>(AppBoxes.agendamentos);
    await Hive.openBox<Funcionario>(AppBoxes.funcionario);
    await Hive.openBox<Cliente>(AppBoxes.clientes);
    await Hive.openBox(AppBoxes.settings);
  }
}
