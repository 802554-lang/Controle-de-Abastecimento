import 'package:flutter/material.dart';

// Tema personalizado para o aplicativo de Controle de Abastecimento
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  
  // Esquema de Cores Base
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blueGrey,
    primary: Colors.blueGrey.shade800, // Cor principal (cabeçalhos, etc.)
    secondary: Colors.teal, // Cor de destaque para botões e ícones (FAB)
    error: Colors.red.shade700,
    background: Colors.grey.shade50, // Fundo leve
  ),
  
  // Estilo da AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blueGrey.shade800,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontSize: 22, // Levemente maior
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    centerTitle: true,
  ),
  
  // Estilo dos Cards (para resumos e listas)
  cardTheme: CardTheme(
    elevation: 6, // Elevação ligeiramente maior
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Mais arredondado
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  ),
  
  // Estilo dos Botões Elevados (CTA - Call to Action)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14), // Um pouco mais de padding
      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      elevation: 4,
    ),
  ),
  
  // Estilo dos Campos de Entrada (TextFields)
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.blueGrey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal, width: 2), // Borda de foco com a cor de destaque
      borderRadius: BorderRadius.circular(10),
    ),
    labelStyle: TextStyle(color: Colors.blueGrey.shade700),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),

  // Estilo para Texto
  textTheme: TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.w700, color: Colors.blueGrey.shade900),
    bodyMedium: TextStyle(color: Colors.blueGrey.shade800),
  ),

  // Estilo para Floating Action Button
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.teal.shade400,
    foregroundColor: Colors.white,
    elevation: 8,
  )
);