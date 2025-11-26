import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class VeiculosScreen extends StatefulWidget {
  final AppState state;
  const VeiculosScreen({super.key, required this.state});

  @override
  _VeiculosScreenState createState() => _VeiculosScreenState();
}

class _VeiculosScreenState extends State<VeiculosScreen> {
  final _formKey = GlobalKey<FormState>();
  String _modelo = '';
  String _marca = '';
  String _placa = '';
  int _ano = DateTime.now().year;
  String _tipoCombustivel = 'Gasolina';

  void _showAddVeiculoDialog() {

    _modelo = ''; _marca = ''; _placa = ''; _ano = DateTime.now().year; _tipoCombustivel = 'Gasolina';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Novo Veículo'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Modelo'),
                    onSaved: (val) => _modelo = val!,
                    validator: (val) => val!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Marca'),
                    onSaved: (val) => _marca = val!,
                    validator: (val) => val!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Placa'),
                    onSaved: (val) => _placa = val!.toUpperCase(),
                    validator: (val) => val!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: _ano.toString(),
                    decoration: InputDecoration(labelText: 'Ano'),
                    keyboardType: TextInputType.number,
                    onSaved: (val) => _ano = int.tryParse(val!) ?? DateTime.now().year,
                    validator: (val) => val!.length != 4 ? 'Ano inválido' : null,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Combustível'),
                    initialValue: _tipoCombustivel,
                    items: ['Gasolina', 'Etanol', 'Diesel', 'Flex']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => _tipoCombustivel = val!,
                    onSaved: (val) => _tipoCombustivel = val!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newVeiculo = Veiculo(
                    id: '',
                    modelo: _modelo,
                    marca: _marca,
                    placa: _placa,
                    ano: _ano,
                    tipoCombustivel: _tipoCombustivel,
                  );
                  widget.state.addVeiculo(newVeiculo);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteVeiculo(Veiculo veiculo) {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir o veículo ${veiculo.modelo}? Todos os abastecimentos serão perdidos.'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: appTheme.colorScheme.error),
            child: Text('Excluir'),
            onPressed: () {
              widget.state.deleteVeiculo(veiculo.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: widget.state.veiculos.length,
          itemBuilder: (context, index) {
            final veiculo = widget.state.veiculos[index];
            return Card(
              child: ListTile(
                leading: Icon(Icons.car_rental, color: appTheme.colorScheme.secondary),
                title: Text('${veiculo.marca} ${veiculo.modelo}'),
                subtitle: Text('Placa: ${veiculo.placa} | Ano: ${veiculo.ano} | Combustível: ${veiculo.tipoCombustivel}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: appTheme.colorScheme.error),
                  onPressed: () => _deleteVeiculo(veiculo),
                ),
              ),
            );
          },
        ),

        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: appTheme.colorScheme.secondary,
            foregroundColor: Colors.white,
            onPressed: _showAddVeiculoDialog,
            heroTag: 'addVeiculo',
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}