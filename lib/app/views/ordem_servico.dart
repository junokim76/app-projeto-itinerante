import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'lista_ordem_servico.dart';

class OrdemServicoPage extends StatefulWidget {
  final String userId;

  const OrdemServicoPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _OrdemServicoPageState createState() => _OrdemServicoPageState();
}

class _OrdemServicoPageState extends State<OrdemServicoPage> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _valorController = TextEditingController();
  TextEditingController _prazoController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? currentUserUid;
  String get recipientUserId => widget.userId;

  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    currentUserUid = user?.uid;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    _prazoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _enviarOrdemServico() async {
    String nome = _nomeController.text.trim();
    String valor = _valorController.text.trim();
    String prazo = _prazoController.text.trim();
    String descricao = _descricaoController.text.trim();

    if (nome.isNotEmpty && valor.isNotEmpty && prazo.isNotEmpty && descricao.isNotEmpty && currentUserUid != null) {
      List<String> participantes = [recipientUserId, currentUserUid!];
      participantes.sort(); // Classifica os IDs em ordem alfabética

      await _firestore.collection('ordens_servico').add({
        'nome': nome,
        'valor': valor,
        'prazo': prazo,
        'descricao': descricao,
        'participantes': participantes,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _nomeController.clear();
      _valorController.clear();
      _prazoController.clear();
      _descricaoController.clear();
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => ListaOrdensServicoPage(userId: recipientUserId,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
        title: const Text('iT\nServiços Itinerantes', textAlign: TextAlign.center),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: 'Valor do serviço',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _prazoController,
                decoration: InputDecoration(
                  labelText: 'Prazo do serviço',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descricaoController,
                maxLines: null, // Permitir várias linhas de texto
                decoration: InputDecoration(
                  labelText: 'Descrição do serviço',
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _enviarOrdemServico,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  child: Text('Enviar Ordem de Serviço', style: TextStyle(color: Colors.black),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
