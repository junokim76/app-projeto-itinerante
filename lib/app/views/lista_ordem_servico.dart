import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../componentes/menu_inferior.dart';

class ListaOrdensServicoPage extends StatefulWidget {
  final String userId;

  ListaOrdensServicoPage({required this.userId});

  @override
  _ListaOrdensServicoPageState createState() => _ListaOrdensServicoPageState();
}

class _ListaOrdensServicoPageState extends State<ListaOrdensServicoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('ordens_servico')
            .where('participantes', arrayContains: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Nenhuma ordem de serviço encontrada.'),
            );
          }

          final ordensServico = snapshot.data!.docs;

          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Ordens de Serviço',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: ordensServico.length,
                  itemBuilder: (context, index) {
                    final ordem = ordensServico[index];
                    final nome = ordem['nome'];
                    final valor = ordem['valor'];
                    final prazo = ordem['prazo'];
                    final descricao = ordem['descricao'];

                    return ListTile(
                      title: Text(nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Valor: $valor'),
                          Text('Prazo: $prazo'),
                          Text('Descrição: $descricao'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
