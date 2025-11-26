import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;
  const HomeScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final abastecimentosPorVeiculo = state.getAbastecimentosPorVeiculo();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://placehold.co/600x250/263238/FFFFFF?text=Controle+de+Frota',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Bem-vindo, ${state.user?.email ?? 'Usuário'}!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text('Resumo dos Veículos', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: appTheme.colorScheme.primary)),
            SizedBox(height: 16),
            if (state.veiculos.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Nenhum veículo cadastrado. Adicione um para começar!', style: TextStyle(fontStyle: FontStyle.italic)),
                ),
              )
            else
              ...state.veiculos.map((veiculo) {
                final abastecimentosDoVeiculo = abastecimentosPorVeiculo[veiculo.id] ?? [];
                final totalAbastecimentos = abastecimentosDoVeiculo.length;
                final ultimoAbastecimento = abastecimentosDoVeiculo.isNotEmpty ? abastecimentosDoVeiculo.first : null;


                double mediaConsumo = totalAbastecimentos > 0
                    ? abastecimentosDoVeiculo.map((a) => a.consumo).reduce((a, b) => a + b) / totalAbastecimentos
                    : 0.0;

                return Card(
                  child: ExpansionTile(
                    leading: Icon(Icons.directions_car, color: appTheme.colorScheme.secondary),
                    title: Text('${veiculo.marca} ${veiculo.modelo} (${veiculo.placa})'),
                    subtitle: Text('Total de Abastecimentos: $totalAbastecimentos'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tipo de Combustível: ${veiculo.tipoCombustivel}'),
                            Divider(),
                            if (ultimoAbastecimento != null) ...[
                              Text('Última KM: ${ultimoAbastecimento.quilometragem} km'),
                              Text('Último Abastecimento: ${DateFormat('dd/MM/yyyy').format(ultimoAbastecimento.data)}'),
                            ] else
                              Text('Nenhum abastecimento registrado.'),
                            SizedBox(height: 10),

                            Text('Média de Consumo (BÔNUS):', style: TextStyle(fontWeight: FontWeight.bold, color: appTheme.colorScheme.primary)),
                            Text('${mediaConsumo.toStringAsFixed(2)} km/l'),
                            SizedBox(height: 8),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.lightGreen.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.lightGreen.shade100)),
                                padding: EdgeInsets.all(8),
                                child: Text('Simulação de Gráfico de Consumo (FL_CHART)', style: TextStyle(fontSize: 12)))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}