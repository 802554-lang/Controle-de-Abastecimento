import 'dart:math';

class Veiculo {
  final String id;
  String modelo;
  String marca;
  String placa;
  int ano;
  String tipoCombustivel;

  Veiculo({
    required this.id,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.ano,
    required this.tipoCombustivel,
  });

  factory Veiculo.fromJson(Map<String, dynamic> json, String id) {
    return Veiculo(
      id: id,
      modelo: json['modelo'] as String,
      marca: json['marca'] as String,
      placa: json['placa'] as String,
      ano: json['ano'] as int,
      tipoCombustivel: json['tipoCombustivel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modelo': modelo,
      'marca': marca,
      'placa': placa,
      'ano': ano,
      'tipoCombustivel': tipoCombustivel,
    };
  }
}

class Abastecimento {
  final String id;
  final DateTime data;
  final double quantidadeLitros;
  final double valorPago;
  final int quilometragem;
  final String tipoCombustivel;
  final String veiculoId;
  final double consumo; // Calculado (Média KM/L)
  final String observacao;

  Abastecimento({
    required this.id,
    required this.data,
    required this.quantidadeLitros,
    required this.valorPago,
    required this.quilometragem,
    required this.tipoCombustivel,
    required this.veiculoId,
    required this.consumo,
    required this.observacao,
  });

  factory Abastecimento.fromJson(Map<String, dynamic> json, String id) {
    final double consumoCalculado = json['consumo'] != null
        ? json['consumo'].toDouble()
        : Random().nextDouble() * 15.0 + 5.0; // Mock de 5 a 20 km/l

    return Abastecimento(
      id: id,
      data: DateTime.parse(json['data']),
      quantidadeLitros: json['quantidadeLitros'].toDouble(),
      valorPago: json['valorPago'].toDouble(),
      quilometragem: json['quilometragem'] as int,
      tipoCombustivel: json['tipoCombustivel'] as String,
      veiculoId: json['veiculoId'] as String,
      consumo: consumoCalculado,
      observacao: json['observacao'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toIso8601String(),
      'quantidadeLitros': quantidadeLitros,
      'valorPago': valorPago,
      'quilometragem': quilometragem,
      'tipoCombustivel': tipoCombustivel,
      'veiculoId': veiculoId,
      'consumo': consumo, 
      'observacao': observacao,
    };
  }
}