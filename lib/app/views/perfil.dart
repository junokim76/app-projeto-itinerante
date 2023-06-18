import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../componentes/menu_inferior.dart';
import '../models/lista_de_servicos.dart';
import '../models/logout.dart';
import 'login.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late String nome = '';
  late String cpf = '';
  late String endereco = '';
  late String email = '';
  late String _selectedService = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usuariosCollection =
      FirebaseFirestore.instance.collection('usuarios');

  @override
  void initState() {
    super.initState();
    // Obter os dados do usuário atual do Firebase Auth
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _fetchUserData(currentUser.uid);
    }
  }

  Future<void> _fetchUserData(String userId) async {
    try {
      // Obter os dados do usuário do Firestore usando o ID do usuário
      DocumentSnapshot userSnapshot =
          await _usuariosCollection.doc(userId).get();
      if (userSnapshot.exists) {
        setState(() {
          nome = userSnapshot.get('nome');
          cpf = userSnapshot.get('cpf');
          endereco = userSnapshot.get('endereco');
          _selectedService = userSnapshot.get('servico');
          email = userSnapshot.get('email');
        });
      }
    } catch (e) {
      print('Erro ao obter dados do usuário: $e');
    }
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
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService.logout(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nome: ${nome ?? ''}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'CPF: ${cpf ?? ''}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Endereço: ${endereco ?? ''}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Serviço: ${_selectedService ?? ''}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: ${email ?? ''}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  onPressed: () {
                    // Implementar o código para editar os dados do perfil
                  },
                  child: const Text(
                    'Editar Perfil',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
