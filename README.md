# BarberGo ✂️ - Documentação do Projeto

Esta documentação detalha o desenvolvimento do aplicativo **BarberGo**, um sistema completo de gestão de agendamentos para barbearias, desenvolvido como parte dos requisitos acadêmicos/técnicos.

---

## 🎯 1. Tema do Projeto
O projeto aborda a **Digitalização e Gestão Local de Serviços de Estética**. O foco é transformar a experiência de agendamento manual (muitas vezes feita por mensagens ou cadernos) em um fluxo digital automatizado, operando de forma totalmente offline e local para garantir privacidade e velocidade.

## 🥅 2. Objetivo
O objetivo principal do **BarberGo** é oferecer uma ferramenta de gestão bifronte:
- **Para o Cliente**: Facilitar a reserva de horários em barbearias próximas, permitindo escolher profissionais, serviços e horários com feedback visual imediato.
- **Para o Barbeiro (Dono do Negócio)**: Centralizar a administração da barbearia, permitindo o controle de faturamento, gestão de equipe, definição de horários de funcionamento e acompanhamento de histórico de clientes.

## 🛠️ 3. Tecnologias Utilizadas
- **Linguagem**: [Dart](https://dart.dev/)
- **Framework**: [Flutter](https://flutter.dev/) (Utilizando componentes de Material Design 3)
- **Banco de Dados Local**: [Hive](https://pub.dev/packages/hive) - Escolhido pela alta performance em persistência NoSQL no dispositivo.
- **Gerenciamento de Estado**: [Provider](https://pub.dev/packages/provider) - Para uma arquitetura reativa e limpa.
- **Internacionalização**: Pacote `intl` e `flutter_localizations` para suporte completo ao padrão brasileiro (`pt_BR`).
- **Arquitetura**: MVC (Model-View-Controller) simplificada e adaptada para Providers.

## 🚀 4. Descrição das Funcionalidades

### 👤 Módulo do Cliente
- **Login e Autenticação**: Validação real de credenciais salvas no banco local.
- **Busca Dinâmica**: Filtro de unidades por nome ou endereço em tempo real.
- **Agendamento Guiado**: Fluxo intuitivo em 4 passos com barra de progresso.
- **Gestão de Horários**: Tela de "Meus Cortes" para acompanhar status (Confirmado, Finalizado, Cancelado) e realizar cancelamentos manuais.
- **Interface Adaptável**: Bloqueio de datas no calendário baseado no expediente configurado pela barbearia.

### 💈 Módulo do Barbeiro (Painel Administrativo)
- **Dashboard de Ganhos**: Cálculo automático de faturamento diário baseado nos serviços finalizados.
- **BarberDash**: Resumo estatístico de atendimentos pendentes e realizados.
- **Minha Equipe**: Cadastro e remoção de barbeiros que prestam serviço na unidade.
- **Gestão de Expediente**: Controle de dias de funcionamento (segunda a domingo) que reflete instantaneamente para o cliente.
- **Configuração de Unidade**: Edição de dados comerciais como nome e endereço da loja.
- **Modo Escuro**: Suporte a tema Dark/Light para melhor ergonomia visual.

## 📸 5. Capturas de Tela
*(Adicione aqui as imagens geradas do aplicativo)*

| Login | Dashboard Barbeiro | Agendamento Cliente |
|---|---|---|
| ![Login](https://via.placeholder.com/200x400?text=Login) | ![Dashboard](https://via.placeholder.com/200x400?text=Dashboard) | ![Agendamento](https://via.placeholder.com/200x400?text=Agendamento) |

## 🧠 6. Principais Desafios Encontrados

1. **Sincronização reativa com Hive**: O maior desafio foi garantir que, quando um cliente fizesse um agendamento ou o barbeiro alterasse o expediente, todas as telas abertas atualizassem os dados instantaneamente sem a necessidade de recarregar o app. Isso foi resolvido utilizando `ValueListenableBuilder` e `notifyListeners()` no Provider.
2. **Arquitetura de Dados NoSQL**: Organizar as relações entre `Funcionario`, `Barbearia` e `Agendamento` em um banco NoSQL (sem o uso de JOINs tradicionais do SQL) exigiu a criação de lógicas de filtragem eficientes em Dart para garantir a performance.
3. **Gestão de Tema (Dark Mode)**: Implementar um Modo Escuro que não apenas trocasse o fundo, mas adaptasse todos os componentes customizados (cards, badges e inputs) mantendo a legibilidade e o Design System.
4. **Localização de Datas**: Configurar o calendário para respeitar os nomes dos dias e meses em português, tratando exceções de inicialização de pacotes nativos.

