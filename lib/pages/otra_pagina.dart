import 'package:flutter/material.dart';

class OtraPagina extends StatefulWidget {
  @override
  _otraPaginaState createState() => _otraPaginaState();
}

class _otraPaginaState extends State<OtraPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Otra página', style: TextStyle(fontSize: 15.0)),
      ),
    );
  }
}
