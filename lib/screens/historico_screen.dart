import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'detail_abastecimento_screen.dart';

class HistoricoScreen extends StatelessWidget {
  final AppState state;
  const HistoricoScreen({super.key, required this.state});

  void _deleteAbastecimento(BuildContext context, Abastecimento abastecimento) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir o abastecimento de ${DateFormat('dd/MM/yyyy').format(abastecimento.data)}?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: appTheme.colorScheme.error),
            child: Text('Excluir'),
            onPressed: () {
              state.deleteAbastecimento(abastecimento.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (state.abastecimentos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Nenhum abastecimento registrado ainda. Comece a controlar seus gastos!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade700),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.abastecimentos.length,
      itemBuilder: (context, index) {
        final abastecimento = state.abastecimentos[index];
        final veiculo = state.veiculos.firstWhere((v) => v.id == abastecimento.veiculoId,
            orElse: () => Veiculo(id: 'unknown', modelo: 'Desconhecido', marca: '', placa: 'N/A', ano: 0, tipoCombustivel: ''));

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: appTheme.colorScheme.secondary.withOpacity(0.1),
              child: Text(abastecimento.consumo.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold, color: appTheme.colorScheme.secondary, fontSize: 12)),
            ),
            title: Text('${veiculo.modelo} - ${DateFormat('dd/MM/yyyy').format(abastecimento.data)}'),
            subtitle: Text('R\$ ${abastecimento.valorPago.toStringAsFixed(2)} - ${abastecimento.quantidadeLitros.toStringAsFixed(2)} L'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: appTheme.colorScheme.error),
              onPressed: () => _deleteAbastecimento(context, abastecimento),
            ),
            onTap: () {

              Navigator.push(context, PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) => DetailAbastecimentoScreen(abastecimento: abastecimento, veiculo: veiculo),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ));
            },
          ),
        );
      },
    );
  }
}