import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../services/firebase_service.dart';

class AppState extends ChangeNotifier {
  final MockFirebaseService _firebaseService = MockFirebaseService();

  MockUser? _user;
  List<Veiculo> _veiculos = [];
  List<Abastecimento> _abastecimentos = [];
  bool _isLoading = false;

  MockUser? get user => _user;
  List<Veiculo> get veiculos => _veiculos;
  List<Abastecimento> get abastecimentos => _abastecimentos;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  Future<void> initAuth() async {
    if (_firebaseService.currentUser != null) {
      _user = _firebaseService.currentUser;
      await fetchData();
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _firebaseService.signIn(email, password);
      await fetchData();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _firebaseService.signUp(email, password);
      await fetchData();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void signOut() {
    _firebaseService.signOut();
    _user = null;
    _veiculos = [];
    _abastecimentos = [];
    notifyListeners();
  }


  Future<void> fetchData() async {
    if (!isAuthenticated) return;
    _setLoading(true);
    try {
      _veiculos = await _firebaseService.getVeiculos();
      _abastecimentos = await _firebaseService.getAbastecimentos();
    } catch (e) {
      print('Erro ao buscar dados: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addVeiculo(Veiculo veiculo) async {
    await _firebaseService.addVeiculo(veiculo);
    await fetchData();
  }

  Future<void> deleteVeiculo(String id) async {
    await _firebaseService.deleteVeiculo(id);
    await fetchData();
  }

  Future<void> addAbastecimento(Abastecimento abastecimento) async {
    await _firebaseService.addAbastecimento(abastecimento);
    await fetchData();
  }

  Future<void> deleteAbastecimento(String id) async {
    await _firebaseService.deleteAbastecimento(id);
    await fetchData();
  }


  Map<String, List<Abastecimento>> getAbastecimentosPorVeiculo() {
    final Map<String, List<Abastecimento>> data = {};
    for (var veiculo in _veiculos) {
      data[veiculo.id] = _abastecimentos
          .where((abast) => abast.veiculoId == veiculo.id)
          .toList();
    }
    return data;
  }
}