import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/hive/boxes.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../models/profissional.dart';
import '../../providers/agendamento_provider.dart';
import '../../shared/widgets/stepper_bar.dart';
import 'servico_screen.dart';

class ProfissionalScreen extends StatelessWidget {
  const ProfissionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgendamentoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Profissional")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: StepperBar(currentStep: 2),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Escolha o profissional", style: AppTypography.headlineMedium),
                  Text("Selecione quem irá cuidar do seu visual hoje.", style: AppTypography.bodyMedium),
                  const SizedBox(height: 24),
                  ValueListenableBuilder(
                    valueListenable: Hive.box<Profissional>(AppBoxes.profissionais).listenable(),
                    builder: (context, Box<Profissional> box, _) {
                      final profissionais = box.values
                          .where((p) => p.barbeariaId == provider.selectedBarbearia?.id)
                          .toList();
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: profissionais.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == profissionais.length) {
                            return _buildAnyProfessionalCard(context);
                          }
                          final p = profissionais[index];
                          return _ProfissionalCard(profissional: p);
                        },
                      );
                    },
                  ),
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
            if (provider.selectedProfissional != null) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicoScreen()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecione um profissional")));
            }
          },
          child: const Text("CONTINUAR PARA AGENDAR"),
        ),
      ),
    );
  }

  Widget _buildAnyProfessionalCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.surfaceContainerLow,
            child: Icon(Icons.group, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Qualquer profissional", style: AppTypography.labelLarge),
                Text("O primeiro disponível para você.", style: AppTypography.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfissionalCard extends StatelessWidget {
  final Profissional profissional;
  const _ProfissionalCard({required this.profissional});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgendamentoProvider>(context);
    final isSelected = provider.selectedProfissional?.id == profissional.id;

    Color dotColor;
    String dotText;
    switch (profissional.disponibilidade) {
      case 'hoje':
        dotColor = Colors.green;
        dotText = "Disponível hoje";
        break;
      case 'amanha':
        dotColor = Colors.orange;
        dotText = "Apenas amanhã";
        break;
      default:
        dotColor = Colors.grey;
        dotText = "Indisponível";
    }

    return GestureDetector(
      onTap: () => provider.selectProfissional(profissional),
      child: Container(
        padding: const EdgeInsets.all(12),
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
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.surfaceContainerLow,
              child: Text(profissional.nome[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profissional.nome, style: AppTypography.labelLarge),
                  Text(
                    profissional.especialidade.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10),
                  ),
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text(dotText, style: AppTypography.labelSmall),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(999)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(profissional.rating.toString(), style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
