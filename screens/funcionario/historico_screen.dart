import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../providers/agendamento_provider.dart';
import '../../shared/widgets/appointment_card.dart';

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<AgendamentoProvider>(context).getHistory();

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar cliente ou serviço...",
                prefixIcon: const Icon(Icons.search),
                fillColor: AppColors.surfaceContainerLow,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final a = history[index];
                return AppointmentCard(
                  appointment: a,
                  showActions: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
