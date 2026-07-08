import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../models/agendamento.dart';

class AppointmentCard extends StatelessWidget {
  final Agendamento appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onFinish;
  final bool showActions;
  final bool isClientView;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onFinish,
    this.showActions = true,
    this.isClientView = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCancelado = appointment.status == 'cancelado';
    final bool isFinalizado = appointment.status == 'finalizado';
    final date = DateFormat('dd/MM/yyyy').format(appointment.dataHora);
    final time = DateFormat('HH:mm').format(appointment.dataHora);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCancelado 
            ? (isDark ? Colors.red.withOpacity(0.1) : Colors.red[50]) 
            : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCancelado 
              ? Colors.red.withOpacity(0.3) 
              : theme.colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.02), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCancelado 
                      ? Colors.red.withOpacity(0.1) 
                      : theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.content_cut,
                  color: isCancelado ? Colors.red : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.servico,
                      style: AppTypography.labelLarge.copyWith(
                        decoration: isCancelado ? TextDecoration.lineThrough : null,
                        color: isCancelado ? theme.disabledColor : theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      isClientView ? appointment.barbeariaNome : appointment.clienteNome,
                      style: AppTypography.labelSmall.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6)
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context, isCancelado, isFinalizado),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12), 
            child: Divider(color: theme.dividerColor.withOpacity(0.1))
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(context, Icons.calendar_today, "Data", date),
              _buildInfoItem(context, Icons.schedule, "Horário", time),
              _buildInfoItem(context, Icons.payments_outlined, "Valor", "R\$ ${appointment.preco.toStringAsFixed(2)}"),
            ],
          ),
          if (showActions && !isCancelado && !isFinalizado) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (onCancel != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text("CANCELAR"),
                    ),
                  ),
                if (onFinish != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onFinish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        minimumSize: const Size(0, 40),
                      ),
                      child: const Text("FINALIZAR", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isCancelado, bool isFinalizado) {
    Color color = Colors.blue;
    String label = appointment.status.toUpperCase();

    if (isCancelado) {
      color = Colors.red;
    } else if (isFinalizado) {
      color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: theme.colorScheme.outline),
            const SizedBox(width: 4),
            Text(label, style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
          ],
        ),
        Text(value, style: AppTypography.labelLarge.copyWith(fontSize: 13, color: theme.colorScheme.onSurface)),
      ],
    );
  }
}
