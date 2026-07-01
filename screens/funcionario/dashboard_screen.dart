import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../providers/agendamento_provider.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../shared/widgets/appointment_card.dart';
import 'agenda_screen.dart';
import 'historico_screen.dart';
import 'perfil_screen.dart';
import 'novo_agendamento_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardContent(),
    const AgendaScreen(),
    const HistoricoScreen(),
    const PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BarberBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NovoAgendamentoScreen())),
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Novo Agendamento", style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            )
          : null,
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final funcionario = auth.usuario;
    final barbearia = auth.barbearia;
    final agendamentoProvider = Provider.of<AgendamentoProvider>(context);
    final theme = Theme.of(context);
    
    final todayAgendamentos = agendamentoProvider.getByDateAndBarbearia(
      DateTime.now(), 
      barbearia?.nome ?? ""
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Text(barbearia?.nome ?? "BarberDash"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  funcionario?.nome[0].toUpperCase() ?? "R", 
                  style: TextStyle(color: theme.colorScheme.primary)
                ),
              ),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                "PAINEL DO COLABORADOR", 
                style: AppTypography.labelSmall.copyWith(
                  letterSpacing: 1.2,
                  color: theme.colorScheme.onSurface.withOpacity(0.6)
                )
              ),
              Text(
                "Olá, ${funcionario?.nome ?? "Barbeiro"}", 
                style: AppTypography.displayMedium.copyWith(color: theme.colorScheme.onSurface)
              ),
              const SizedBox(height: 8),
              Text(
                "Sua agenda de hoje está ${todayAgendamentos.isEmpty ? 0 : ((todayAgendamentos.length / 20) * 100).toInt()}% ocupada.",
                style: AppTypography.bodyMedium.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              ),
              const SizedBox(height: 24),

              _buildEarningsCard(context, agendamentoProvider),
              const SizedBox(height: 16),

              _buildStatsRow(context, todayAgendamentos),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Próximos Atendimentos", style: AppTypography.labelLarge.copyWith(color: theme.colorScheme.onSurface)),
                  Icon(Icons.filter_list, size: 20, color: theme.colorScheme.onSurface),
                ],
              ),
              const SizedBox(height: 16),

              if (todayAgendamentos.isEmpty)
                const Center(child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text("Nenhum atendimento para hoje"),
                ))
              else
                ...todayAgendamentos.take(5).map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppointmentCard(
                    appointment: a,
                    onFinish: () => agendamentoProvider.finalizarAtendimento(a.id),
                    onCancel: () => agendamentoProvider.cancelarAgendamento(a.id),
                  ),
                )),

              const SizedBox(height: 80),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsCard(BuildContext context, AgendamentoProvider provider) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FATURAMENTO HOJE", 
                style: AppTypography.labelSmall.copyWith(color: Colors.white.withOpacity(0.8))
              ),
              const SizedBox(height: 4),
              Text(
                "R\$ ${provider.getTodayEarnings().toStringAsFixed(2)}", 
                style: AppTypography.headlineMedium.copyWith(color: Colors.white)
              ),
            ],
          ),
          const Icon(Icons.payments_outlined, color: Colors.white, size: 40),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, List todayAgendamentos) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _buildStatCard(context, "Total", todayAgendamentos.length.toString(), theme.colorScheme.primary),
        const SizedBox(width: 12),
        _buildStatCard(context, "Feitos", todayAgendamentos.where((a) => a.status == 'finalizado').length.toString(), Colors.green),
        const SizedBox(width: 12),
        _buildStatCard(context, "Pendentes", todayAgendamentos.where((a) => a.status == 'aguardando').length.toString(), theme.colorScheme.error),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          children: [
            Text(
              label, 
              style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))
            ),
            Text(
              value, 
              style: AppTypography.labelLarge.copyWith(color: color, fontSize: 18)
            ),
          ],
        ),
      ),
    );
  }
}
