import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/agendamento.dart';
import '../models/barbearia.dart';
import '../models/profissional.dart';
import '../core/hive/boxes.dart';
import 'package:uuid/uuid.dart';

class AgendamentoProvider with ChangeNotifier {
  final Box<Agendamento> _box = Hive.box<Agendamento>(AppBoxes.agendamentos);

  // Flow state for Cliente
  Barbearia? selectedBarbearia;
  Profissional? selectedProfissional;
  String? selectedServico;
  int selectedDuracao = 0;
  double selectedPreco = 0.0;
  DateTime? selectedDataHora;

  List<Agendamento> get agendamentos => _box.values.toList();

  List<Agendamento> getByDate(DateTime date) {
    return _box.values.where((a) {
      return a.dataHora.year == date.year &&
             a.dataHora.month == date.month &&
             a.dataHora.day == date.day;
    }).toList();
  }

  List<Agendamento> getByDateAndBarbearia(DateTime date, String barbeariaNome) {
    return _box.values.where((a) {
      return a.dataHora.year == date.year &&
             a.dataHora.month == date.month &&
             a.dataHora.day == date.day &&
             a.barbeariaNome == barbeariaNome;
    }).toList();
  }

  List<Agendamento> getHistory() {
    return _box.values.where((a) => a.status == 'finalizado' || a.status == 'cancelado').toList();
  }

  double getTodayEarnings() {
    final now = DateTime.now();
    return _box.values
        .where((a) => a.dataHora.year == now.year &&
                     a.dataHora.month == now.month &&
                     a.dataHora.day == now.day &&
                     a.status == 'finalizado')
        .fold(0.0, (sum, a) => sum + a.preco);
  }

  void selectBarbearia(Barbearia barbearia) {
    selectedBarbearia = barbearia;
    notifyListeners();
  }

  void selectProfissional(Profissional profissional) {
    selectedProfissional = profissional;
    notifyListeners();
  }

  void selectServico(String servico, int duracao, double preco) {
    selectedServico = servico;
    selectedDuracao = duracao;
    selectedPreco = preco;
    notifyListeners();
  }

  void selectDataHora(DateTime dataHora) {
    selectedDataHora = dataHora;
    notifyListeners();
  }

  void resetSelection() {
    selectedBarbearia = null;
    selectedProfissional = null;
    selectedServico = null;
    selectedDuracao = 0;
    selectedPreco = 0.0;
    selectedDataHora = null;
    notifyListeners();
  }

  Future<void> confirmAgendamento({String? clienteNome, String? obs}) async {
    final novo = Agendamento(
      id: const Uuid().v4(),
      clienteNome: clienteNome ?? "Cliente",
      servico: selectedServico!,
      duracao: selectedDuracao,
      preco: selectedPreco,
      barbeiroNome: selectedProfissional?.nome ?? "Qualquer",
      barbeariaNome: selectedBarbearia!.nome,
      dataHora: selectedDataHora!,
      status: 'confirmado',
      observacoes: obs ?? "",
    );

    await _box.add(novo);
    resetSelection();
  }

  Future<void> addAgendamento(Agendamento agendamento) async {
    await _box.add(agendamento);
    notifyListeners();
  }

  Future<void> cancelarAgendamento(String id) async {
    final index = _box.values.toList().indexWhere((a) => a.id == id);
    if (index != -1) {
      final a = _box.getAt(index)!;
      final atualizado = Agendamento(
        id: a.id,
        clienteNome: a.clienteNome,
        servico: a.servico,
        duracao: a.duracao,
        preco: a.preco,
        barbeiroNome: a.barbeiroNome,
        barbeariaNome: a.barbeariaNome,
        dataHora: a.dataHora,
        status: 'cancelado',
        observacoes: a.observacoes,
      );
      await _box.putAt(index, atualizado);
      notifyListeners();
    }
  }

  Future<void> excluirAgendamento(String id) async {
    final index = _box.values.toList().indexWhere((a) => a.id == id);
    if (index != -1) {
      await _box.deleteAt(index);
      notifyListeners();
    }
  }

  Future<void> finalizarAtendimento(String id) async {
    final index = _box.values.toList().indexWhere((a) => a.id == id);
    if (index != -1) {
      final a = _box.getAt(index)!;
      final atualizado = Agendamento(
        id: a.id,
        clienteNome: a.clienteNome,
        servico: a.servico,
        duracao: a.duracao,
        preco: a.preco,
        barbeiroNome: a.barbeiroNome,
        barbeariaNome: a.barbeariaNome,
        dataHora: a.dataHora,
        status: 'finalizado',
        observacoes: a.observacoes,
      );
      await _box.putAt(index, atualizado);
      notifyListeners();
    }
  }
}
