import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/lista_de_servicos.dart';
import 'login.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  String nome = '';
  String cpf = '';
  String endereco = '';
  String? _selectedService;
  String email = '';
  String senha = '';
  String confirma_senha = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> cadastrar() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Cria uma coleção "usuarios" no Firestore
      CollectionReference usuariosCollection =
          FirebaseFirestore.instance.collection('usuarios');

      // Cria um documento com o ID do usuário
      DocumentReference usuarioDoc =
          usuariosCollection.doc(userCredential.user!.uid);

      // Adiciona os dados do usuário ao documento
      await usuarioDoc.set({
        'nome': nome,
        'cpf': cpf,
        'endereco': endereco,
        'servico': _selectedService,
        'email': email,
      });

      print('Usuário cadastrado com sucesso: ${userCredential.user?.uid}');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
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
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: [
                TextField(
                  onChanged: (text) {
                    setState(() {
                      nome = text;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      cpf = text;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      endereco = text;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Endereço',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedService,
                  decoration: InputDecoration(
                    labelText: 'Serviço',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    hintText: 'Selecione um serviço',
                  ),
                  items: servicos.map((String service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedService = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      email = text;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Email de Login',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      senha = text;
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      confirma_senha = text;
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirme sua senha',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: () {
                    cadastrar();
                  },
                  child: const Text('Cadastrar', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
