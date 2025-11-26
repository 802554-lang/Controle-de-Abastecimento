import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../models/data_models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class AbastecimentoScreen extends StatefulWidget {
  final AppState state;
  const AbastecimentoScreen({super.key, required this.state});

  @override
  _AbastecimentoScreenState createState() => _AbastecimentoScreenState();
}

class _AbastecimentoScreenState extends State<AbastecimentoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _veiculoSelecionadoId;
  DateTime _data = DateTime.now();
  double? _quantidadeLitros;
  double? _valorPago;
  int? _quilometragem;
  String _tipoCombustivel = 'Gasolina';
  String _observacao = '';

  @override
  void initState() {
    super.initState();

    if (widget.state.veiculos.isNotEmpty) {
      _veiculoSelecionadoId = widget.state.veiculos.first.id;
      _tipoCombustivel = widget.state.veiculos.first.tipoCombustivel;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _data,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (picked != null && picked != _data) {
      setState(() {
        _data = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _veiculoSelecionadoId != null) {
      _formKey.currentState!.save();

      final newAbastecimento = Abastecimento(
        id: '',
        data: _data,
        quantidadeLitros: _quantidadeLitros!,
        valorPago: _valorPago!,
        quilometragem: _quilometragem!,
        tipoCombustivel: _tipoCombustivel,
        veiculoId: _veiculoSelecionadoId!,
        consumo: Random().nextDouble() * 15.0 + 5.0, 
        observacao: _observacao,
      );

      widget.state.addAbastecimento(newAbastecimento);


      _formKey.currentState!.reset();
      setState(() {
        _data = DateTime.now();
        _observacao = '';
        _veiculoSelecionadoId = widget.state.veiculos.isNotEmpty ? widget.state.veiculos.first.id : null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Abastecimento registrado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.veiculos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Você precisa cadastrar um veículo antes de registrar um abastecimento.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade700),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Veículo'),
              initialValue: _veiculoSelecionadoId,
              items: widget.state.veiculos
                  .map((v) => DropdownMenuItem(
                        value: v.id,
                        child: Text('${v.marca} ${v.modelo} (${v.placa})'),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _veiculoSelecionadoId = val;
                  final veiculo = widget.state.veiculos.firstWhere((v) => v.id == val);
                  _tipoCombustivel = veiculo.tipoCombustivel;
                });
              },
              validator: (val) => val == null ? 'Selecione um veículo' : null,
            ),
            SizedBox(height: 16),


            ListTile(
              leading: Icon(Icons.calendar_today, color: appTheme.colorScheme.secondary),
              title: Text('Data: ${DateFormat('dd/MM/yyyy').format(_data)}'),
              trailing: Icon(Icons.edit),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 16),

            TextFormField(
              decoration: InputDecoration(labelText: 'Quantidade de Litros'),
              keyboardType: TextInputType.number,
              onSaved: (val) => _quantidadeLitros = double.tryParse(val!),
              validator: (val) => val!.isEmpty || double.tryParse(val) == null ? 'Informe os litros' : null,
            ),
            SizedBox(height: 16),


            TextFormField(
              decoration: InputDecoration(labelText: 'Valor Total Pago (R\$)'),
              keyboardType: TextInputType.number,
              onSaved: (val) => _valorPago = double.tryParse(val!),
              validator: (val) => val!.isEmpty || double.tryParse(val) == null ? 'Informe o valor pago' : null,
            ),
            SizedBox(height: 16),


            TextFormField(
              decoration: InputDecoration(labelText: 'Quilometragem (KM)'),
              keyboardType: TextInputType.number,
              onSaved: (val) => _quilometragem = int.tryParse(val!),
              validator: (val) => val!.isEmpty || int.tryParse(val) == null ? 'Informe a KM atual' : null,
            ),
            SizedBox(height: 16),


            TextFormField(
              initialValue: _tipoCombustivel,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Tipo de Combustível',
                icon: Icon(Icons.gas_meter),
              ),
            ),
            SizedBox(height: 16),


            TextFormField(
              decoration: InputDecoration(labelText: 'Observação (Opcional)'),
              maxLines: 2,
              onSaved: (val) => _observacao = val ?? '',
            ),
            SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: widget.state.isLoading ? null : _submit,
              icon: widget.state.isLoading
                  ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Icon(Icons.save),
              label: Text('REGISTRAR ABASTECIMENTO'),
            ),
          ],
        ),
      ),
    );
  }
}