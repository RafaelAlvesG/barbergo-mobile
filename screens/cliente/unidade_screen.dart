import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/hive/boxes.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../models/barbearia.dart';
import '../../providers/agendamento_provider.dart';
import '../../shared/widgets/stepper_bar.dart';
import 'profissional_screen.dart';

class UnidadeScreenContent extends StatefulWidget {
  const UnidadeScreenContent({super.key});

  @override
  State<UnidadeScreenContent> createState() => _UnidadeScreenContentState();
}

class _UnidadeScreenContentState extends State<UnidadeScreenContent> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: StepperBar(currentStep: 1),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                    decoration: const InputDecoration(
                      hintText: "Buscar barbearia...",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined, size: 32, color: theme.colorScheme.primary),
                          Text(
                            "Mapa de Unidades", 
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.primary)
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Unidades Próximas", 
                    style: AppTypography.labelLarge.copyWith(color: theme.colorScheme.onSurface)
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
                    valueListenable: Hive.box<Barbearia>(AppBoxes.barbearias).listenable(),
                    builder: (context, Box<Barbearia> box, _) {
                      final barbearias = box.values
                          .where((b) => b.nome.toLowerCase().contains(_searchQuery))
                          .toList();
                      
                      if (barbearias.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Text("Nenhuma barbearia encontrada."),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: barbearias.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _BarbeariaCard(barbearia: barbearias[index]),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomSheet(context),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.05), 
            blurRadius: 10
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          final provider = Provider.of<AgendamentoProvider>(context, listen: false);
          if (provider.selectedBarbearia != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfissionalScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Por favor, selecione uma unidade antes.")),
            );
          }
        },
        child: const Text("CONTINUAR"),
      ),
    );
  }
}

class _BarbeariaCard extends StatelessWidget {
  final Barbearia barbearia;
  const _BarbeariaCard({required this.barbearia});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgendamentoProvider>(context);
    final isSelected = provider.selectedBarbearia?.id == barbearia.id;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => provider.selectBarbearia(barbearia),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.05) : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.storefront, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    barbearia.nome, 
                    style: AppTypography.labelLarge.copyWith(color: theme.colorScheme.onSurface)
                  ),
                  Text(
                    barbearia.endereco, 
                    style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)), 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.chevron_right,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
