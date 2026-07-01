import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../providers/agendamento_provider.dart';
import '../../shared/widgets/stepper_bar.dart';
import 'data_horario_screen.dart';

class ServicoScreen extends StatelessWidget {
  const ServicoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Serviço")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: StepperBar(currentStep: 3),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Escolha o serviço", style: AppTypography.headlineMedium),
                  const SizedBox(height: 24),
                  _ServiceCard(nome: "Corte de Cabelo", duracao: "30 min", preco: 45.0, icon: Icons.content_cut),
                  const SizedBox(height: 12),
                  _ServiceCard(nome: "Barba", duracao: "20 min", preco: 35.0, icon: Icons.face),
                  const SizedBox(height: 12),
                  _ServiceCard(nome: "Corte + Barba", duracao: "50 min", preco: 75.0, icon: Icons.face_retouching_natural),
                  const SizedBox(height: 12),
                  _ServiceCard(nome: "Sobrancelha", duracao: "15 min", preco: 20.0, icon: Icons.star),
                  const SizedBox(height: 12),
                  _ServiceCard(nome: "Outro serviço", duracao: "Consultar", preco: 0.0, icon: Icons.more_horiz),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          onPressed: () {
            final provider = Provider.of<AgendamentoProvider>(context, listen: false);
            if (provider.selectedServico != null) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DataHorarioScreen()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecione um serviço")));
            }
          },
          child: const Text("CONTINUAR"),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String nome;
  final String duracao;
  final double preco;
  final IconData icon;

  const _ServiceCard({
    required this.nome,
    required this.duracao,
    required this.preco,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgendamentoProvider>(context);
    final isSelected = provider.selectedServico == nome;

    return GestureDetector(
      onTap: () => provider.selectServico(nome, int.tryParse(duracao.split(' ')[0]) ?? 0, preco),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nome, style: AppTypography.labelLarge),
                  Text(duracao, style: AppTypography.labelSmall),
                ],
              ),
            ),
            Text(
              preco > 0 ? "R\$ ${preco.toStringAsFixed(0)}" : "Consultar",
              style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}
