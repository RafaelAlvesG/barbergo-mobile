import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import 'equipe_screen.dart';
import 'unidade_config_screen.dart';
import '../login/login_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final f = auth.usuario;

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeader(f),
            const SizedBox(height: 32),

            _buildSectionHeader("EQUIPE E UNIDADE"),
            _buildInfoCard([
              ListTile(
                leading: const Icon(Icons.group_outlined, color: AppColors.primary),
                title: const Text("Minha Equipe"),
                subtitle: const Text("Gerenciar barbeiros da loja"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EquipeScreen())),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                title: const Text("Minha Unidade"),
                subtitle: const Text("Editar endereço e nome da loja"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UnidadeConfigScreen())),
              ),
            ]),

            const SizedBox(height: 24),
            _buildSectionHeader("PREFERÊNCIAS"),
            _buildInfoCard([
              SwitchListTile(
                title: const Text("Modo Escuro"),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: themeProvider.isDarkMode,
                onChanged: (val) => themeProvider.toggleTheme(val),
                activeColor: AppColors.primary,
              ),
            ]),

            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                auth.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error.withOpacity(0.1),
                foregroundColor: AppColors.error,
                elevation: 0,
              ),
              icon: const Icon(Icons.logout),
              label: const Text("SAIR DA CONTA"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            user?.nome[0].toUpperCase() ?? "B",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        Text(user?.nome ?? "Barbeiro", style: AppTypography.displayMedium.copyWith(fontSize: 24)),
        Text(user?.email ?? "", style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: AppTypography.labelSmall.copyWith(letterSpacing: 1.1, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}
