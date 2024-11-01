import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/despesa.dart';

class DespesaViewModel {
  final _firestore = FirebaseFirestore.instance.collection('despesas');

  /// Stream para obter as 5 despesas mais recentes
  Stream<List<Despesa>> get despesasRecentesStream {
    return _firestore
        .orderBy('data', descending: true) // Ordena pela data de forma decrescente
        .limit(5) // Limita a 5 documentos
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Despesa.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  /// Stream para obter todas as despesas do mês atual em ordem decrescente
  Stream<List<Despesa>> get despesasDoMesStream {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    return _firestore
        .where('data', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .orderBy('data', descending: true) // Ordena pela data em ordem decrescente
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Despesa.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  /// Método para adicionar uma nova despesa ao Firestore com validação
  Future<String?> adicionarDespesa(Despesa despesa) async {
    if (!_isValid(despesa)) {
      return "O título não pode estar vazio e o valor deve ser maior que zero.";
    }

    try {
      await _firestore.add(despesa.toFirestore());
      return null; // Indica sucesso
    } catch (e) {
      return "Erro ao adicionar a despesa: $e";
    }
  }

  /// Método para atualizar uma despesa existente no Firestore
  Future<String?> atualizarDespesa(String id, Despesa despesa) async {
    if (!_isValid(despesa)) {
      return "O título não pode estar vazio e o valor deve ser maior que zero.";
    }

    try {
      await _firestore.doc(id).update(despesa.toFirestore());
      return null; // Indica sucesso
    } catch (e) {
      return "Erro ao atualizar a despesa: $e";
    }
  }

  /// Método para excluir uma despesa no Firestore
  Future<String?> excluirDespesa(String id) async {
    try {
      await _firestore.doc(id).delete();
      return null; // Indica sucesso
    } catch (e) {
      return "Erro ao excluir a despesa: $e";
    }
  }

  /// Validação dos dados da despesa
  bool _isValid(Despesa despesa) {
    return despesa.titulo.isNotEmpty && despesa.valor > 0;
  }
}
