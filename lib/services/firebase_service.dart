import '../models/data_models.dart';


class MockUser {
  final String uid;
  final String email;
  MockUser(this.uid, this.email);
}


class MockFirebaseService {
  MockUser? _currentUser;
  final Map<String, Map<String, dynamic>> _veiculosDB = {};
  final Map<String, Map<String, dynamic>> _abastecimentosDB = {};

  String get currentUid => _currentUser?.uid ?? 'mock-user-uid-001';
  MockUser? get currentUser => _currentUser;

  Future<MockUser> signIn(String email, String password) async {
    if (email.contains('@') && password.length >= 6) {
      _currentUser = MockUser(currentUid, email);
      return _currentUser!;
    }
    throw Exception('Login falhou: Email ou senha inválidos/incorretos.');
  }

  Future<MockUser> signUp(String email, String password) async {
    if (email.contains('@') && password.length >= 6) {
      _currentUser = MockUser(currentUid, email);
      return _currentUser!;
    }
    throw Exception('Cadastro falhou: Preencha todos os campos corretamente.');
  }

  void signOut() {
    _currentUser = null;
  }


  Future<List<Veiculo>> getVeiculos() async {
    final List<Veiculo> veiculos = _veiculosDB.entries
        .where((entry) => entry.value['userId'] == currentUid)
        .map((entry) => Veiculo.fromJson(entry.value, entry.key))
        .toList();
    await Future.delayed(Duration(milliseconds: 300));
    return veiculos;
  }

  Future<void> addVeiculo(Veiculo veiculo) async {
    final String newId = DateTime.now().millisecondsSinceEpoch.toString();
    _veiculosDB[newId] = veiculo.toJson()..['userId'] = currentUid;
    await Future.delayed(Duration(milliseconds: 100));
  }

  Future<void> deleteVeiculo(String veiculoId) async {
    _veiculosDB.remove(veiculoId);
    _abastecimentosDB.removeWhere((key, value) => value['veiculoId'] == veiculoId && value['userId'] == currentUid);
    await Future.delayed(Duration(milliseconds: 100));
  }


  Future<List<Abastecimento>> getAbastecimentos() async {
    final List<Abastecimento> abastecimentos = _abastecimentosDB.entries
        .where((entry) => entry.value['userId'] == currentUid)
        .map((entry) => Abastecimento.fromJson(entry.value, entry.key))
        .toList();
    await Future.delayed(Duration(milliseconds: 300));
    abastecimentos.sort((a, b) => b.data.compareTo(a.data));
    return abastecimentos;
  }

  Future<void> addAbastecimento(Abastecimento abastecimento) async {
    final String newId = DateTime.now().millisecondsSinceEpoch.toString();
    _abastecimentosDB[newId] = abastecimento.toJson()..['userId'] = currentUid;
    await Future.delayed(Duration(milliseconds: 100));
  }

  Future<void> deleteAbastecimento(String abastecimentoId) async {
    _abastecimentosDB.remove(abastecimentoId);
    await Future.delayed(Duration(milliseconds: 100));
  }
}