import 'package:cloud_firestore/cloud_firestore.dart';

class Despesa {
  final String? id; // Tornando o id opcional
  final String titulo;
  final String categoria;
  final double valor;
  final DateTime data;
  final bool renovacao;

  Despesa({
    this.id, // `id` agora é opcional
    required this.titulo,
    required this.categoria,
    required this.valor,
    required this.data,
    this.renovacao = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'categoria': categoria,
      'valor': valor,
      'data': data,
      'renovacao': renovacao,
    };
  }

  static Despesa fromFirestore(Map<String, dynamic> data, String id) {
    return Despesa(
      id: id,
      titulo: data['titulo'],
      categoria: data['categoria'],
      valor: data['valor'],
      data: (data['data'] as Timestamp).toDate(),
      renovacao: data['renovacao'] ?? false,
    );
  }
}
