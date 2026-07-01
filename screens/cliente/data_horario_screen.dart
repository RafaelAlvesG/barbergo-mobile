import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../providers/agendamento_provider.dart';
import '../../shared/widgets/stepper_bar.dart';
import 'confirmacao_screen.dart';

class DataHorarioScreen extends StatefulWidget {
  const DataHorarioScreen({super.key});

  @override
  State<DataHorarioScreen> createState() => _DataHorarioScreenState();
}

class _DataHorarioScreenState extends State<DataHorarioScreen> {
  DateTime _selectedDay = DateTime.now();
  String? _selectedTime;

  final List<String> _times = [
    "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
    "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
    "15:00", "15:30", "16:00", "16:30", "17:00", "17:30",
    "18:00", "18:30"
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgendamentoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Data e Horário")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: StepperBar(currentStep: 4),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumo Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.store, color: AppColors.primary, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.selectedBarbearia?.nome ?? "", style: AppTypography.labelLarge),
                              Text(provider.selectedProfissional?.nome ?? "", style: AppTypography.labelSmall),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            minimumSize: const Size(0, 32),
                          ),
                          child: const Text("Alterar", style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text("Escolha a data", style: AppTypography.labelLarge),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final day = DateTime.now().add(Duration(days: index));
                        final isSelected = day.day == _selectedDay.day;
                        
                        // NOVO: Verifica se a barbearia abre nesse dia da semana
                        final abreHoje = provider.selectedBarbearia?.diasTrabalho.contains(day.weekday) ?? true;

                        return GestureDetector(
                          onTap: abreHoje ? () => setState(() => _selectedDay = day) : null,
                          child: Opacity(
                            opacity: abreHoje ? 1.0 : 0.4,
                            child: Container(
                              width: 64,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? AppColors.primary : AppColors.outlineVariant),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('E', 'pt_BR').format(day).toUpperCase(),
                                    style: TextStyle(color: isSelected ? Colors.white : AppColors.onSurfaceVariant, fontSize: 10),
                                  ),
                                  Text(
                                    day.day.toString(),
                                    style: TextStyle(color: isSelected ? Colors.white : AppColors.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat('MMM', 'pt_BR').format(day).toUpperCase(),
                                    style: TextStyle(color: isSelected ? Colors.white : AppColors.onSurfaceVariant, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text("Escolha o horário", style: AppTypography.labelLarge),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: _times.length,
                    itemBuilder: (context, index) {
                      final time = _times[index];
                      final isSelected = _selectedTime == time;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTime = time),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSelected ? AppColors.primary : AppColors.outlineVariant),
                          ),
                          child: Center(
                            child: Text(
                              time,
                              style: TextStyle(color: isSelected ? Colors.white : AppColors.onSurface, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Resumo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow("Serviço", provider.selectedServico ?? ""),
                        _buildSummaryRow("Profissional", provider.selectedProfissional?.nome ?? ""),
                        _buildSummaryRow("Data", DateFormat('dd/MM/yyyy').format(_selectedDay)),
                        _buildSummaryRow("Horário", _selectedTime ?? "--:--"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          onPressed: () async {
            if (_selectedTime != null) {
              final parts = _selectedTime!.split(':');
              final dateTime = DateTime(
                _selectedDay.year, _selectedDay.month, _selectedDay.day,
                int.parse(parts[0]), int.parse(parts[1]),
              );
              provider.selectDataHora(dateTime);
              await provider.confirmAgendamento();
              if (mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ConfirmacaoScreen()));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecione um horário")));
            }
          },
          child: const Text("Confirmar agendamento"),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
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
