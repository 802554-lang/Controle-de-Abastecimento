import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final AppState state;
  final Function(int) onItemTap;

  const AppDrawer({super.key, required this.state, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: appTheme.colorScheme.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.directions_car, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text('Controle de Abastecimento', style: TextStyle(color: Colors.white, fontSize: 18)),
                // Exibe o email do usuário
                Text(state.user?.email ?? 'Usuário', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Início'),
            onTap: () {
              onItemTap(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_car_filled),
            title: Text('Meus Veículos'),
            onTap: () {
              onItemTap(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.local_gas_station),
            title: Text('Registrar Abastecimento'),
            onTap: () {
              onItemTap(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Histórico de Abastecimentos'),
            onTap: () {
              onItemTap(3);
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Sair', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              state.signOut();
            },
          ),
        ],
      ),
    );
  }
}