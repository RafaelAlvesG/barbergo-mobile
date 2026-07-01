import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../providers/auth_provider.dart';
import '../login/login_screen.dart';
import 'unidade_screen.dart';
import 'meus_agendamentos_screen.dart';

class ClienteMainScreen extends StatefulWidget {
  const ClienteMainScreen({super.key});

  @override
  State<ClienteMainScreen> createState() => _ClienteMainScreenState();
}

class _ClienteMainScreenState extends State<ClienteMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const UnidadeScreenContent(),
    const MeusAgendamentosScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BarberGo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.outline,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Reservar"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Meus Cortes"),
        ],
      ),
    );
  }
}
