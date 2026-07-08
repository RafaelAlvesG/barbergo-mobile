import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../providers/auth_provider.dart';
import '../cliente/cliente_main_screen.dart';
import '../funcionario/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedRole = 'Cliente';
  
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  
  final _regNomeBarbearia = TextEditingController();
  final _regNomeDono = TextEditingController();
  final _regEmail = TextEditingController();
  final _regSenha = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _regNomeBarbearia.dispose();
    _regNomeDono.dispose();
    _regEmail.dispose();
    _regSenha.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleEntrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    
    if (email.isEmpty || senha.isEmpty) {
      _showSnack("Preencha e-mail e senha!", isError: true);
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isFunc = _selectedRole == 'Funcionário';
    
    final sucesso = await auth.login(email, senha, isFunc);
    
    if (sucesso) {
      if (!mounted) return;
      if (isFunc) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ClienteMainScreen()));
      }
    } else {
      _showSnack("E-mail ou senha de $_selectedRole incorretos!", isError: true);
    }
  }

  Future<void> _handleCadastrar() async {
    final nome = _regNomeDono.text.trim();
    final email = _regEmail.text.trim();
    final senha = _regSenha.text.trim();
    final barbearia = _regNomeBarbearia.text.trim();

    if (email.isEmpty || senha.isEmpty || nome.isEmpty) {
      _showSnack("Preencha os campos obrigatórios!", isError: true);
      return;
    }
    
    final auth = Provider.of<AuthProvider>(context, listen: false);
    String? erro;
    
    if (_selectedRole == 'Funcionário') {
      if (barbearia.isEmpty) {
        _showSnack("Nome da barbearia é obrigatório!", isError: true);
        return;
      }
      erro = await auth.cadastrar(
        nome: nome,
        email: email,
        senha: senha,
        nomeBarbearia: barbearia,
      );
    } else {
      erro = await auth.cadastrar(
        nome: nome,
        email: email,
        senha: senha,
      );
    }

    if (erro != null) {
      _showSnack(erro, isError: true);
    } else {
      _showSnack("Cadastro realizado como $_selectedRole! Faça login.");
      _tabController.animateTo(0);
      _regNomeBarbearia.clear();
      _regNomeDono.clear();
      _regEmail.clear();
      _regSenha.clear();
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.content_cut, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              Text("BarberGo", style: AppTypography.displayMedium),
              const SizedBox(height: 40),
              
              _buildRoleToggle(context),
              const SizedBox(height: 24),
              
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.outline,
                indicatorColor: Theme.of(context).colorScheme.primary,
                dividerColor: Colors.transparent,
                tabs: const [Tab(text: "ENTRAR"), Tab(text: "CRIAR CONTA")],
              ),
              
              SizedBox(
                height: 420,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginForm(),
                    _buildRegisterForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleToggle(BuildContext context) {
    return Row(
      children: [
        _roleButton(context, "Cliente"),
        const SizedBox(width: 12),
        _roleButton(context, "Funcionário"),
      ],
    );
  }

  Widget _roleButton(BuildContext context, String role) {
    bool isSel = _selectedRole == role;
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSel ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSel ? colorScheme.primary : colorScheme.outline),
          ),
          child: Center(
            child: Text(
              role,
              style: TextStyle(
                color: isSel ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: "E-mail", prefixIcon: Icon(Icons.email_outlined)),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _senhaController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Senha", prefixIcon: Icon(Icons.lock_outline)),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _handleEntrar,
          child: const Text("ENTRAR NO SISTEMA"),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          if (_selectedRole == 'Funcionário') 
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: _regNomeBarbearia,
                decoration: const InputDecoration(labelText: "Nome da Barbearia", prefixIcon: Icon(Icons.storefront)),
              ),
            ),
          TextField(
            controller: _regNomeDono,
            decoration: const InputDecoration(labelText: "Seu Nome", prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _regEmail,
            decoration: const InputDecoration(labelText: "E-mail", prefixIcon: Icon(Icons.email_outlined)),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _regSenha,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Senha", prefixIcon: Icon(Icons.lock_outline)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleCadastrar,
            child: const Text("CRIAR MINHA CONTA"),
          ),
        ],
      ),
    );
  }
}
