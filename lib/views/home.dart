import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodels/despesa_viewmodel.dart';
import '../models/despesa.dart';

/// Definição de tema para cores e estilos utilizados em toda a aplicação
class AppTheme {
  static const Color backgroundColor = Color(0xFF1E1E1E);
  static const Color cardColor = Color(0xFF262626);
  static const Color iconBackgroundColor = Color(0xFF2C2C2C);
  static const Color textColor = Colors.white;
  static const Color subtitleColor = Color(0xFF9B9B9B);
  static const String fontFamily = 'Satoshi';

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: 23.0);
  static const SizedBox verticalSpacing = SizedBox(height: 40);
  static const SizedBox smallSpacing = SizedBox(height: 10);

  static const TextStyle headerTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w300,
    color: textColor,
  );

  static const TextStyle titleTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textColor,
  );

  static const BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );
}

/// Tela principal da aplicação com seções de informações do usuário, despesas mensais e atividades recentes
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppTheme.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 35),
              UserInfoSection(),
              AppTheme.verticalSpacing,
              MonthlyExpenseCard(),
              AppTheme.verticalSpacing,
              ActivitiesSection(),
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

/// Seção de informações do usuário, incluindo saudação e botão de logout
class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: 'Olá, ', style: AppTheme.headerTextStyle),
              TextSpan(
                text: 'Usuário!',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: AppTheme.textColor,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ],
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: AppTheme.cardColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                icon: Image.asset(
                  'assets/img/bot_sair.png',
                  width: 18,
                  height: 18,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

/// Card que exibe o total de despesas mensais usando o DespesaViewModel para consulta
class MonthlyExpenseCard extends StatelessWidget {
  const MonthlyExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = DespesaViewModel();

    return StreamBuilder<List<Despesa>>(
      stream: viewModel.despesasDoMesStream, // Usando o stream para todas as despesas do mês
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar total de despesas"));
        }

        final despesas = snapshot.data ?? [];
        double totalMonthlyExpenses = despesas.fold(0, (sum, despesa) => sum + despesa.valor);

        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.cardDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Despesas deste mês',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          color: AppTheme.subtitleColor,
                          fontSize: 16,
                        ),
                      ),
                      AppTheme.smallSpacing,
                      Text(
                        formatCurrency(totalMonthlyExpenses),
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 38,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 24,
              right: 24,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset('assets/img/bot_adicionar.png', width: 35, height: 35),
                onPressed: () => Navigator.pushNamed(context, '/adicionar'),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Função para formatar valores no padrão de moeda brasileiro (R$)
String formatCurrency(double value) {
  final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  return formatter.format(value);
}

/// Seção que exibe as atividades recentes, listando as despesas mais recentes
class ActivitiesSection extends StatelessWidget {
  const ActivitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = DespesaViewModel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Atividade recente',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppTheme.textColor,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/relatorio'),
              child: _buildGradientText('Ver tudo'),
            ),
          ],
        ),
        AppTheme.smallSpacing,
        StreamBuilder<List<Despesa>>(
          stream: viewModel.despesasRecentesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Erro ao carregar despesas"));
            }
            final despesas = snapshot.data ?? [];
            return Column(
              children: despesas.map((despesa) {
                return ActivityTile(
                  title: despesa.titulo,
                  value: despesa.valor,
                  category: despesa.categoria,
                  imagePath: _getImagePath(despesa.categoria),
                  date: despesa.data,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  /// Cria um texto com gradiente para o botão "Ver tudo"
  Widget _buildGradientText(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF9C8680), Color(0xFFCEBBB5)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Gera o caminho da imagem da categoria, removendo acentos e espaços
  String _getImagePath(String? category) {
    if (category == null) return 'assets/img/default.png';
    final formattedCategory = removeDiacritics(category)
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll('ç', 'c');
    return 'assets/img/cat_$formattedCategory.png';
  }
}

/// Card de atividade individual que exibe título, valor, categoria, ícone e data
class ActivityTile extends StatelessWidget {
  final String title;
  final double value;
  final String category;
  final String imagePath;
  final DateTime date;

  const ActivityTile({
    super.key,
    required this.title,
    required this.value,
    required this.category,
    required this.imagePath,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(imagePath, width: 24, height: 24, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.titleTextStyle),
                  const SizedBox(height: 2),
                  Text(category, style: const TextStyle(fontSize: 14, color: AppTheme.subtitleColor)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatCurrency(value),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.textColor),
              ),
              const SizedBox(height: 2),
              Text(
                timeAgo(date),
                style: const TextStyle(fontSize: 14, color: AppTheme.subtitleColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Função que calcula o tempo relativo entre a data e o momento atual
String timeAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inSeconds < 60) return 'agora há pouco';
  if (difference.inMinutes < 60) return 'há ${difference.inMinutes} ${difference.inMinutes == 1 ? "minuto" : "minutos"}';
  if (difference.inHours < 24) return 'há ${difference.inHours} ${difference.inHours == 1 ? "hora" : "horas"}';
  if (difference.inDays < 7) return 'há ${difference.inDays} ${difference.inDays == 1 ? "dia" : "dias"}';
  if (difference.inDays < 30) return 'há ${(difference.inDays / 7).floor()} ${difference.inDays ~/ 7 == 1 ? "semana" : "semanas"}';
  if (difference.inDays < 365) return 'há ${(difference.inDays / 30).floor()} ${difference.inDays ~/ 30 == 1 ? "mês" : "meses"}';

  return 'há ${(difference.inDays / 365).floor()} ${difference.inDays ~/ 365 == 1 ? "ano" : "anos"}';
}
