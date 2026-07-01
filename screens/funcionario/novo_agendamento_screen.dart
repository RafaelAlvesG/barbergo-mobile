import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../models/agendamento.dart';
import '../../providers/agendamento_provider.dart';
import '../../providers/auth_provider.dart';

class NovoAgendamentoScreen extends StatefulWidget {
  const NovoAgendamentoScreen({super.key});

  @override
  State<NovoAgendamentoScreen> createState() => _NovoAgendamentoScreenState();
}

class _NovoAgendamentoScreenState extends State<NovoAgendamentoScreen> {
  final _nomeController = TextEditingController();
  final _obsController = TextEditingController();
  String _selectedService = "Corte de Cabelo";
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = "09:00";

  final List<Map<String, dynamic>> _services = [
    {"nome": "Corte de Cabelo", "preco": 45.0, "duracao": 30},
    {"nome": "Barba", "preco": 35.0, "duracao": 20},
    {"nome": "Combo Completo", "preco": 75.0, "duracao": 50},
    {"nome": "Sobrancelha", "preco": 20.0, "duracao": 15},
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final serviceData = _services.firstWhere((s) => s['nome'] == _selectedService);

    return Scaffold(
      appBar: AppBar(title: const Text("Novo Agendamento")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome do Cliente",
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 24),
            Text("Serviço", style: AppTypography.labelLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _services.map((s) {
                final isSelected = _selectedService == s['nome'];
                return ChoiceChip(
                  label: Text(s['nome']),
                  selected: isSelected,
                  onSelected: (val) => setState(() => _selectedService = s['nome']),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.onSurface),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) setState(() => _selectedDate = date);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: "Data"),
                      child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedTime,
                    decoration: const InputDecoration(labelText: "Horário"),
                    items: ["09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"]
                        .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) => setState(() => _selectedTime = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _obsController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Observações", alignLabelWithHint: true),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildResumoRow("Serviço", _selectedService),
                  _buildResumoRow("Duração", "${serviceData['duracao']} min"),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("R\$ ${serviceData['preco'].toStringAsFixed(2)}", style: AppTypography.headlineMedium.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_nomeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Digite o nome do cliente")));
                  return;
                }
                
                final parts = _selectedTime.split(':');
                final date = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, int.parse(parts[0]), int.parse(parts[1]));

                final agendamento = Agendamento(
                  id: const Uuid().v4(),
                  clienteNome: _nomeController.text.trim(),
                  servico: _selectedService,
                  duracao: serviceData['duracao'],
                  preco: serviceData['preco'],
                  barbeiroNome: auth.usuario?.nome ?? "Barbeiro",
                  barbeariaNome: auth.barbearia?.nome ?? "Minha Barbearia",
                  dataHora: date,
                  status: 'confirmado',
                  observacoes: _obsController.text.trim(),
                );

                await Provider.of<AgendamentoProvider>(context, listen: false).addAgendamento(agendamento);
                if (mounted) Navigator.pop(context);
              },
              child: const Text("Confirmar Agendamento"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.labelSmall),
          Text(value, style: AppTypography.labelLarge),
        ],
      ),
    );
  }
}
