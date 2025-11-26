import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/app_drawer.dart';
import 'home_screen.dart';
import 'veiculos_screen.dart';
import 'abastecimento_screen.dart';
import 'historico_screen.dart';

class MainScreen extends StatefulWidget {
  final AppState state;
  const MainScreen({super.key, required this.state});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  final List<String> _titles = ['Início', 'Meus Veículos', 'Registrar Abastecimento', 'Histórico de Abastecimentos'];

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(state: widget.state),
      VeiculosScreen(state: widget.state),
      AbastecimentoScreen(state: widget.state),
      HistoricoScreen(state: widget.state),
    ];

    widget.state.fetchData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.account_circle, size: 30),
          )
        ],
      ),
      drawer: AppDrawer(state: widget.state, onItemTap: _onItemTapped),
      body: AnimatedSwitcher( 
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: _screens[_selectedIndex],
        ),
      ),
    );
  }
}