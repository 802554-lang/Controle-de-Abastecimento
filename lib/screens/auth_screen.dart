import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  final AppState state;
  const AuthScreen({super.key, required this.state});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLogin = true;

  Future<void> _submitAuthForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (_isLogin) {
          await widget.state.signIn(_email, _password);
        } else {
          await widget.state.signUp(_email, _password);
        }
      } catch (e) {
        // Exibir mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: appTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_car_filled, size: 80, color: appTheme.colorScheme.primary),
                      SizedBox(height: 10),
                      Text(
                        _isLogin ? 'Login' : 'Cadastre-se',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: appTheme.colorScheme.primary),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'E-mail'),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (val) => _email = val!.trim(),
                        validator: (val) => val!.isEmpty || !val.contains('@') ? 'E-mail inválido' : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Senha'),
                        obscureText: true,
                        onSaved: (val) => _password = val!,
                        validator: (val) => val!.length < 6 ? 'A senha deve ter pelo menos 6 caracteres' : null,
                      ),
                      SizedBox(height: 30),
                      widget.state.isLoading
                          ? CircularProgressIndicator(color: appTheme.colorScheme.secondary)
                          : ElevatedButton(
                              onPressed: _submitAuthForm,
                              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                              child: Text(_isLogin ? 'ENTRAR' : 'CADASTRAR'),
                            ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin ? 'Não tem conta? Cadastre-se' : 'Já tem conta? Faça Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}