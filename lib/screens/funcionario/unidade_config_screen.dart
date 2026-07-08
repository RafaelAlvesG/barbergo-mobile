import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../providers/auth_provider.dart';

class UnidadeConfigScreen extends StatefulWidget {
  const UnidadeConfigScreen({super.key});

  @override
  State<UnidadeConfigScreen> createState() => _UnidadeConfigScreenState();
}

class _UnidadeConfigScreenState extends State<UnidadeConfigScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _enderecoController;

  @override
  void initState() {
    super.initState();
    final barbearia = Provider.of<AuthProvider>(context, listen: false).barbearia;
    _nomeController = TextEditingController(text: barbearia?.nome);
    _enderecoController = TextEditingController(text: barbearia?.endereco);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  void _salvar() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final b = auth.barbearia;
    
    if (b != null) {
      b.nome = _nomeController.text.trim();
      b.endereco = _enderecoController.text.trim();
      await b.save();
      auth.atualizarBarbearia();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dados da unidade atualizados!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurações da Unidade")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("DETALHES DO NEGÓCIO", style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome da Barbearia",
                prefixIcon: Icon(Icons.storefront),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _enderecoController,
              decoration: const InputDecoration(
                labelText: "Endereço Completo",
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text("SALVAR ALTERAÇÕES"),
            ),
          ],
        ),
      ),
    );
  }
}
