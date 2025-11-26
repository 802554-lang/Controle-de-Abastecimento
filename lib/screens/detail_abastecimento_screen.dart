import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_models.dart';
import '../theme/app_theme.dart';

class DetailAbastecimentoScreen extends StatelessWidget {
  final Abastecimento abastecimento;
  final Veiculo veiculo;
  const DetailAbastecimentoScreen({super.key, required this.abastecimento, required this.veiculo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Abastecimento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(context, Icons.directions_car, 'Veículo', '${veiculo.marca} ${veiculo.modelo} (${veiculo.placa})'),
            _buildDetailCard(context, Icons.calendar_today, 'Data', DateFormat('dd/MM/yyyy').format(abastecimento.data)),
            _buildDetailCard(context, Icons.speed, 'Quilometragem', '${abastecimento.quilometragem} KM'),
            _buildDetailCard(context, Icons.money, 'Valor Pago', 'R\$ ${abastecimento.valorPago.toStringAsFixed(2)}'),
            _buildDetailCard(context, Icons.local_gas_station, 'Litros', '${abastecimento.quantidadeLitros.toStringAsFixed(2)} L'),
            _buildDetailCard(context, Icons.trending_up, 'Consumo Estimado', '${abastecimento.consumo.toStringAsFixed(2)} KM/L'),
            _buildDetailCard(context, Icons.note, 'Observação', abastecimento.observacao.isEmpty ? 'Nenhuma' : abastecimento.observacao),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, IconData icon, String title, String subtitle) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: appTheme.colorScheme.primary),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 14)),
      ),
    );
  }
}