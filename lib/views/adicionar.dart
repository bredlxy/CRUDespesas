import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:crud_despesas/views/home.dart';
import 'package:crud_despesas/viewmodels/despesa_viewmodel.dart';
import 'package:crud_despesas/models/despesa.dart';

class Adicionar extends StatefulWidget {
  const Adicionar({super.key});

  @override
  AdicionarState createState() => AdicionarState();
}

class AdicionarState extends State<Adicionar> {
  final DespesaViewModel _viewModel = DespesaViewModel();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  String selectedCategory = 'Assinaturas';
  bool _autoRenew = false;

  static const List<String> _categories = [
    'Alimentação', 'Assinaturas', 'Compras Pessoais', 'Educação', 'Lazer',
    'Outros', 'Emergências', 'Investimentos', 'Moradia', 'Saúde',
    'Serviços', 'Transporte'
  ];

  static const _formPadding = EdgeInsets.all(30.0);
  static const _dropdownPadding = EdgeInsets.symmetric(horizontal: 15.0);
  static const _containerDecoration = BoxDecoration(
    color: Color(0xFF262626),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  /// Função para adicionar uma nova despesa ao Firestore usando o ViewModel
  Future<void> _addExpense() async {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text.replaceAll(',', '.')) ?? 0;

    final despesa = Despesa(
      titulo: title,
      valor: value,
      categoria: selectedCategory,
      renovacao: _autoRenew,
      data: DateTime.now(),
    );

    final errorMessage = await _viewModel.adicionarDespesa(despesa);

    if (mounted) {
      if (errorMessage != null) {
        _showError(errorMessage);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    }
  }

  /// Exibe uma mensagem de erro no formato de snackbar na parte inferior da tela
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: _buildAppBar(context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            _buildFormContainer(),
          ],
        ),
      ),
    );
  }

  /// Constrói a AppBar com o título da página e botão de voltar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Image.asset('assets/img/seta_esq.png', width: 15, height: 15),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Nova despesa',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói o container que envolve os campos do formulário de adição de despesa
  Widget _buildFormContainer() {
    return Container(
      width: double.infinity,
      padding: _formPadding,
      decoration: _containerDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _titleController,
            hintText: "Ex: Netflix",
            label: "Nome da despesa",
            iconPath: 'assets/img/ico_editar.png',
          ),
          const SizedBox(height: 20),
          _buildDropdownField(),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _valueController,
            hintText: "R\$0,00",
            label: "Valor",
            iconPath: 'assets/img/ico_valor.png',
          ),
          const SizedBox(height: 20),
          _buildAutoRenewSwitch(),
          const SizedBox(height: 30),
          _buildAddButton(),
        ],
      ),
    );
  }

  /// Constrói um campo de texto com ícone e estilo personalizados para o formulário
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required String iconPath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF9B9B9B), fontFamily: 'Satoshi', fontWeight: FontWeight.w300)),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(color: const Color(0xFF333333), borderRadius: BorderRadius.circular(20)),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF333333),
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0x4D9B9B9B), fontFamily: 'Satoshi', fontWeight: FontWeight.w300),
              prefixIcon: Padding(padding: const EdgeInsets.all(15.0), child: Image.asset(iconPath, width: 18, height: 18)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Satoshi', fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }

  /// Constrói o campo de seleção de categoria como um DropdownButton estilizado
  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Categoria", style: TextStyle(color: Color(0xFF9B9B9B), fontFamily: 'Satoshi', fontWeight: FontWeight.w300)),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 55,
          padding: _dropdownPadding,
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
              items: _categories.map<DropdownMenuItem<String>>((String category) {
                final categoryKey = removeDiacritics(category.toLowerCase().replaceAll(" ", ""));
                return DropdownMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/img/cat_$categoryKey.png', width: 25, height: 25),
                      ),
                      const SizedBox(width: 15),
                      Text(category, style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Satoshi', fontWeight: FontWeight.w300)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Constrói o switch para alternar a renovação automática da despesa
  Widget _buildAutoRenewSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _autoRenew = !_autoRenew),
            child: Opacity(
              opacity: _autoRenew ? 0.9 : 0.2,
              child: Image.asset('assets/img/bot_renovar.png', width: 25, height: 25),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Renovar automaticamente todo mês',
            style: TextStyle(color: Color(0xFF9B9B9B), fontFamily: 'Satoshi', fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  /// Constrói o botão para adicionar a despesa, com estilo de gradiente
  Widget _buildAddButton() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9C8680), Color(0xFFCEBBB5)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          onPressed: _addExpense,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Adicionar",
            style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'Satoshi', fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
