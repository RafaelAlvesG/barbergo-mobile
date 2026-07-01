import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/hive/boxes.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../models/profissional.dart';
import '../../providers/auth_provider.dart';

class EquipeScreen extends StatefulWidget {
  const EquipeScreen({super.key});

  @override
  State<EquipeScreen> createState() => _EquipeScreenState();
}

class _EquipeScreenState extends State<EquipeScreen> {
  final _nomeController = TextEditingController();

  void _addBarbeiro() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final barbeariaId = auth.barbearia?.id;

    if (barbeariaId == null) return;
    if (_nomeController.text.isEmpty) return;

    final pBox = Hive.box<Profissional>(AppBoxes.profissionais);

    // Salva apenas como profissional para aparecer para os clientes
    await pBox.add(Profissional(
      id: DateTime.now().millisecondsSinceEpoch, // ID único simples
      barbeariaId: barbeariaId,
      nome: _nomeController.text,
      especialidade: "Barbeiro",
      disponibilidade: "hoje",
      rating: 5.0,
    ));

    Navigator.pop(context);
    _nomeController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Barbeiro adicionado!"), backgroundColor: Colors.green)
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final barbeariaId = auth.barbearia?.id;

    return Scaffold(
      appBar: AppBar(title: const Text("Minha Equipe")),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Profissional>(AppBoxes.profissionais).listenable(),
        builder: (context, Box<Profissional> box, _) {
          final equipe = box.values.where((p) => p.barbeariaId == barbeariaId).toList();

          if (equipe.isEmpty) {
            return const Center(child: Text("Nenhum barbeiro cadastrado."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: equipe.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final p = equipe[index];
              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.outlineVariant),
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(p.nome[0], style: const TextStyle(color: AppColors.primary)),
                ),
                title: Text(p.nome, style: AppTypography.labelLarge),
                subtitle: const Text("Barbeiro", style: TextStyle(fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => p.delete(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddModal(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24, right: 24, top: 24
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Novo Barbeiro", style: AppTypography.headlineMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome do Barbeiro",
                hintText: "Ex: Ricardo Silva",
              ),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addBarbeiro,
              child: const Text("CADASTRAR"),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
