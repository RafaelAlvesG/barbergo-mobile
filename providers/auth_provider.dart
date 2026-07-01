import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/funcionario.dart';
import '../models/barbearia.dart';
import '../models/cliente.dart';
import '../core/hive/boxes.dart';

class AuthProvider with ChangeNotifier {
  dynamic usuario;
  Barbearia? barbearia;

  Future<bool> login(String email, String senha, bool isFuncionario) async {
    final e = email.trim().toLowerCase();
    final s = senha.trim();

    if (isFuncionario) {
      final box = Hive.box<Funcionario>(AppBoxes.funcionario);
      final f = box.values.cast<Funcionario?>().firstWhere(
        (u) => u?.email.toLowerCase() == e && u?.senha == s,
        orElse: () => null,
      );
      if (f != null) {
        usuario = f;
        barbearia = Hive.box<Barbearia>(AppBoxes.barbearias).values.firstWhere((b) => b.id == f.barbeariaId);
        notifyListeners();
        return true;
      }
    } else {
      final box = Hive.box<Cliente>(AppBoxes.clientes);
      final c = box.values.cast<Cliente?>().firstWhere(
        (u) => u?.email.toLowerCase() == e && u?.senha == s,
        orElse: () => null,
      );
      if (c != null) {
        usuario = c;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<String?> cadastrar({
    required String nome,
    required String email,
    required String senha,
    String? nomeBarbearia,
    String? enderecoBarbearia,
  }) async {
    final e = email.trim().toLowerCase();
    
    // Check duplicado
    final jaExisteFunc = Hive.box<Funcionario>(AppBoxes.funcionario).values.any((u) => u.email.toLowerCase() == e);
    final jaExisteCli = Hive.box<Cliente>(AppBoxes.clientes).values.any((u) => u.email.toLowerCase() == e);
    
    if (jaExisteFunc || jaExisteCli) return "E-mail já cadastrado!";

    if (nomeBarbearia != null) {
      final bBox = Hive.box<Barbearia>(AppBoxes.barbearias);
      final id = bBox.length + 1;
      await bBox.add(Barbearia(
        id: id, 
        nome: nomeBarbearia, 
        endereco: enderecoBarbearia ?? "Endereço não informado"
      ));
      await Hive.box<Funcionario>(AppBoxes.funcionario).add(
        Funcionario(nome: nome, email: email, senha: senha, telefone: "", barbeariaId: id)
      );
    } else {
      await Hive.box<Cliente>(AppBoxes.clientes).add(Cliente(nome: nome, email: email, senha: senha));
    }
    return null;
  }

  void atualizarBarbearia() {
    notifyListeners();
  }

  void logout() {
    usuario = null;
    barbearia = null;
    notifyListeners();
  }
}
