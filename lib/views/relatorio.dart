import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diacritic/diacritic.dart';
import '../viewmodels/despesa_viewmodel.dart';
import '../models/despesa.dart';

/// Tela de relatório que exibe as despesas do mês atual
class Relatorio extends StatefulWidget {
  const Relatorio({super.key});

  @override
  RelatorioState createState() => RelatorioState();
}

class RelatorioState extends State<Relatorio> {
  /// Instância do ViewModel para gerenciar operações no Firestore
  final DespesaViewModel _viewModel = DespesaViewModel();

  /// Exibe o modal de edição para atualizar a despesa selecionada
  void _showEditModal(Despesa despesa) {
    final TextEditingController titleController = TextEditingController(text: despesa.titulo);
    final TextEditingController valueController = TextEditingController(text: despesa.valor.toString());
    String selectedCategory = despesa.categoria;
    String? errorTitle;
    String? errorValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1F1F1F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Editar despesa",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: titleController,
                      iconPath: 'assets/img/ico_editar.png',
                      hintText: 'Nome da despesa',
                      errorText: errorTitle,
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownField(selectedCategory, (newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    }),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: valueController,
                      iconPath: 'assets/img/ico_valor.png',
                      hintText: 'Valor',
                      errorText: errorValue,
                      isNumeric: true,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            errorTitle = titleController.text.isEmpty ? "O título não pode estar vazio" : null;
                            errorValue = double.tryParse(valueController.text) == null ? "Insira um valor válido" : null;
                          });
                          if (errorTitle == null && errorValue == null) {
                            _viewModel.atualizarDespesa(
                              despesa.id!,
                              Despesa(
                                id: despesa.id!,
                                titulo: titleController.text,
                                categoria: selectedCategory,
                                valor: double.tryParse(valueController.text) ?? 0.0,
                                data: despesa.data,
                                renovacao: despesa.renovacao,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text("Salvar", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Confirma e executa a exclusão de uma despesa
  void _deleteExpense(String id) async {
    final confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F1F1F),
          title: const Text("Confirmar exclusão", style: TextStyle(color: Colors.white)),
          content: const Text("Tem certeza de que deseja excluir esta despesa?", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await _viewModel.excluirDespesa(id);
      setState(() {}); // Atualiza a página para refletir a exclusão
    }
  }

  /// Constrói um campo de texto personalizado com ícone e estilo para o formulário
  Widget _buildTextField({
    required TextEditingController controller,
    required String iconPath,
    required String hintText,
    String? errorText,
    bool isNumeric = false,
  }) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF333333), borderRadius: BorderRadius.circular(20)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF333333),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0x4D9B9B9B), fontWeight: FontWeight.w300),
          prefixIcon: Padding(padding: const EdgeInsets.all(15.0), child: Image.asset(iconPath, width: 18, height: 18)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          errorText: errorText,
        ),
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  /// Constrói um campo dropdown para seleção da categoria da despesa
  Widget _buildDropdownField(String selectedCategory, ValueChanged<String?> onChanged) {
    final categories = [
      'Assinaturas', 'Alimentação', 'Compras Pessoais', 'Educação', 'Lazer', 'Outros', 'Emergências',
      'Investimentos', 'Moradia', 'Saúde', 'Serviços', 'Transporte'
    ];

    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(color: const Color(0xFF333333), borderRadius: BorderRadius.circular(20)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          icon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset('assets/img/seta_baixo.png', width: 15, height: 15, color: Colors.white),
          ),
          isExpanded: true,
          dropdownColor: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(20),
          items: categories.map((category) {
            final imagePath = 'assets/img/cat_${removeDiacritics(category.toLowerCase().replaceAll(" ", ""))}.png';
            return DropdownMenuItem<String>(
              value: category,
              child: Row(
                children: [
                  Padding(padding: const EdgeInsets.all(10.0), child: Image.asset(imagePath, width: 25, height: 25)),
                  const SizedBox(width: 15),
                  Text(category, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<List<Despesa>>(
          stream: _viewModel.despesasDoMesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text("Erro ao carregar despesas"));
            }

            final despesas = snapshot.data!;
            final total = despesas.fold(0.0, (sum, item) => sum + item.valor);

            return ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/img/seta_esq.png', width: 15, height: 15),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Despesas',
                      style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Image.asset('assets/img/bot_adicionar.png', width: 32, height: 32),
                      onPressed: () => Navigator.pushNamed(context, '/adicionar'),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Text(
                  'Total do mês: R\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                ...despesas.map((despesa) => _buildExpenseItem(despesa)),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Constrói o card de exibição de cada despesa, com título, valor, categoria e opções de editar/excluir
  Widget _buildExpenseItem(Despesa despesa) {
    final imagePath = 'assets/img/cat_${removeDiacritics(despesa.categoria.toLowerCase().replaceAll(" ", ""))}.png';
    final formattedDate = DateFormat('dd/MM/yyyy – HH:mm').format(despesa.data);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(color: const Color(0xFF262626), borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF363636),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(despesa.titulo, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  Text(despesa.categoria, style: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 12)),
                  const SizedBox(height: 5),
                  Text(formattedDate, style: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 12)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('R\$${despesa.valor.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              Row(
                children: [
                  IconButton(
                    icon: Image.asset('assets/img/ico_editar.png', width: 18, height: 18),
                    onPressed: () => _showEditModal(despesa),
                  ),
                  IconButton(
                    icon: Image.asset('assets/img/ico_deletar.png', width: 18, height: 18),
                    onPressed: () => _deleteExpense(despesa.id!),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
