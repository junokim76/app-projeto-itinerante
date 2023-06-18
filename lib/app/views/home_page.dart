import 'package:appprojetoitinerante/app/views/resultado_busca.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../componentes/menu_inferior.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn().then((loggedIn) {
      if (!loggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  Future<bool> checkUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
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
        title: const Text(
          'iT\nServiços Itinerantes',
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 50),
            ),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    String buscar = searchController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuscaPage(
                          buscar: buscar,
                          selectedService: '',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: const Image(image: AssetImage('assets/image6.png')),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
