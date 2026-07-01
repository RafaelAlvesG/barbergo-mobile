import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../providers/agendamento_provider.dart';
import '../../shared/widgets/appointment_card.dart';

class MeusAgendamentosScreen extends StatelessWidget {
  const MeusAgendamentosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgendamentoProvider>(context);
    final meusAgendamentos = provider.agendamentos.reversed.toList();

    return Scaffold(
      body: meusAgendamentos.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: meusAgendamentos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final a = meusAgendamentos[index];
                return AppointmentCard(
                  appointment: a,
                  isClientView: true,
                  onCancel: () => _confirmarCancelamento(context, a.id),
                );
              },
            ),
    );
  }

  void _confirmarCancelamento(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancelar Horário"),
        content: const Text("Tem certeza que deseja cancelar este agendamento?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("VOLTAR")),
          TextButton(
            onPressed: () {
              Provider.of<AgendamentoProvider>(context, listen: false).cancelarAgendamento(id);
              Navigator.pop(context);
            },
            child: const Text("CANCELAR AGORA", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 64, color: AppColors.outlineVariant),
          const SizedBox(height: 16),
          Text("Você não tem agendamentos", style: AppTypography.labelLarge),
          Text("Que tal marcar um corte agora?", style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}
