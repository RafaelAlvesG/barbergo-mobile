# BarberGo

App mobile de agendamento para barbearias, feito em Flutter. O sistema funciona **100% offline**, com dados salvos localmente no dispositivo via Hive.

Há dois perfis de uso:

- **Cliente** — busca unidades, escolhe profissional, serviço e horário, e acompanha os agendamentos.
- **Funcionário** — gerencia a barbearia: agenda, equipe, faturamento, expediente e histórico.

---

## Tecnologias

| Tecnologia | Uso |
|---|---|
| [Flutter](https://flutter.dev/) | Interface (Material Design 3) |
| [Dart](https://dart.dev/) | Linguagem |
| [Hive](https://pub.dev/packages/hive) | Banco de dados local NoSQL |
| [Provider](https://pub.dev/packages/provider) | Gerenciamento de estado |
| [intl](https://pub.dev/packages/intl) | Datas e formatação em `pt_BR` |
| [table_calendar](https://pub.dev/packages/table_calendar) | Calendário da agenda |
| [google_fonts](https://pub.dev/packages/google_fonts) | Tipografia |
| [uuid](https://pub.dev/packages/uuid) | IDs únicos de agendamento |

---

## Funcionalidades

### Cliente

- Login e cadastro com validação local
- Busca de barbearias por nome ou endereço
- Agendamento guiado em 4 etapas (unidade → profissional → serviço → data/horário)
- Bloqueio de dias fora do expediente da barbearia
- Tela **Meus Cortes** com status: confirmado, finalizado e cancelado
- Cancelamento de agendamentos

### Funcionário

- Dashboard com faturamento do dia e resumo de atendimentos
- Agenda com calendário e criação manual de agendamentos
- Histórico de atendimentos finalizados e cancelados
- Gestão da equipe (cadastro e remoção de barbeiros)
- Configuração da unidade (nome e endereço)
- Controle de dias de funcionamento (segunda a domingo)
- Modo escuro

---

## Estrutura do projeto

```
lib/
├── app/                    # MaterialApp e configuração global
├── core/
│   ├── hive/               # Inicialização e boxes do Hive
│   └── theme/              # Cores, tipografia e temas claro/escuro
├── models/                 # Entidades e adaptadores Hive (.g.dart)
├── providers/              # Auth, agendamento e tema
├── screens/
│   ├── cliente/            # Fluxo do cliente
│   ├── funcionario/        # Painel administrativo
│   └── login/              # Login e cadastro
├── shared/widgets/         # Componentes reutilizáveis
└── main.dart               # Ponto de entrada
```

### Modelos de dados

| Modelo | Descrição |
|---|---|
| `Barbearia` | Unidade com nome, endereço e dias de trabalho |
| `Profissional` | Barbeiro vinculado a uma barbearia |
| `Funcionario` | Dono/gestor com login e vínculo à barbearia |
| `Cliente` | Usuário final com login |
| `Agendamento` | Reserva com serviço, horário, preço e status |

---

## Como rodar

> **Atenção:** este repositório contém o código-fonte Dart. Para executar o app, é necessário um projeto Flutter completo com `pubspec.yaml` e pastas de plataforma (`android/`, `ios/`, etc.).

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado
- Emulador Android/iOS ou dispositivo físico

### Dependências necessárias

Adicione ao `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  provider: ^6.1.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  intl: ^0.19.0
  uuid: ^4.5.1
  google_fonts: ^6.2.1
  table_calendar: ^3.1.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.13
```

### Comandos

```bash
# Na raiz do projeto Flutter
flutter pub get
flutter run
```

### Primeiro uso

Não há dados pré-carregados. Para testar:

1. Abra o app e vá em **Criar Conta**
2. Cadastre-se como **Funcionário** (cria barbearia + conta de gestor)
3. No painel, adicione barbeiros em **Perfil → Minha Equipe**
4. Cadastre um **Cliente** em outra conta (ou deslogue e crie)
5. Faça um agendamento pelo fluxo do cliente

---

## Arquitetura

O app segue uma estrutura **MVC simplificada** com Providers:

- **Models** — entidades Hive com adaptadores gerados
- **Views** — telas em `screens/` e widgets em `shared/`
- **Controllers** — `AuthProvider`, `AgendamentoProvider` e `ThemeProvider`

A reatividade entre telas usa `ChangeNotifier` + `Provider` e `ValueListenableBuilder` do Hive para atualizar a UI sem recarregar o app.

---

## Status dos agendamentos

| Status | Significado |
|---|---|
| `confirmado` | Agendamento ativo, aguardando atendimento |
| `finalizado` | Serviço concluído — entra no faturamento |
| `cancelado` | Cancelado pelo cliente ou funcionário |

---

## Licença

Projeto acadêmico/técnico. Uso livre para estudo e adaptação.
