import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../providers/agendamento_provider.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/appointment_card.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  final List<String> _diasNomes = [
    "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira",
    "Sexta-feira", "Sábado", "Domingo"
  ];

  void _abrirConfigExpediente() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            final b = auth.barbearia;
            if (b == null) return const SizedBox();
            
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Dias de Trabalho", style: AppTypography.headlineMedium),
                  const Text("Selecione os dias que a barbearia abre", style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final diaId = index + 1;
                        final selecionado = b.diasTrabalho.contains(diaId);
                        return CheckboxListTile(
                          title: Text(_diasNomes[index]),
                          value: selecionado,
                          activeColor: AppColors.primary,
                          onChanged: (val) async {
                            List<int> novosDias = List.from(b.diasTrabalho);
                            if (val == true) {
                              novosDias.add(diaId);
                            } else {
                              novosDias.remove(diaId);
                            }
                            b.diasTrabalho = novosDias;
                            await b.save(); 
                            auth.atualizarBarbearia();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("FECHAR")),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final provider = Provider.of<AgendamentoProvider>(context);
    final dayAgendamentos = provider.getByDateAndBarbearia(
      _selectedDay!, auth.barbearia?.nome ?? ""
    );

    final isTrabalho = auth.barbearia?.diasTrabalho.contains(_selectedDay!.weekday) ?? true;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _abrirConfigExpediente,
          )
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: AppColors.surfaceContainer, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ),
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            enabledDayPredicate: (day) => auth.barbearia?.diasTrabalho.contains(day.weekday) ?? true,
          ),
          const Divider(),
          if (!isTrabalho)
            const Expanded(child: Center(child: Text("😴 Barbearia fechada neste dia.")))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                itemCount: dayAgendamentos.isEmpty ? 1 : dayAgendamentos.length,
                itemBuilder: (context, index) {
                  if (dayAgendamentos.isEmpty) return const Center(child: Text("Nenhum compromisso."));
                  final a = dayAgendamentos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppointmentCard(
                      appointment: a,
                      onFinish: () => provider.finalizarAtendimento(a.id),
                      onCancel: () => _confirmarCancelamento(context, provider, a.id),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _confirmarCancelamento(BuildContext context, AgendamentoProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancelar Agendamento"),
        content: const Text("Deseja marcar este horário como cancelado?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("NÃO")),
          TextButton(
            onPressed: () {
              provider.cancelarAgendamento(id);
              Navigator.pop(context);
            },
            child: const Text("CANCELAR", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
