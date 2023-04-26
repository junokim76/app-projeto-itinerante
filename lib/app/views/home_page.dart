import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu aplicativo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black, 
          fontSize: 24,),
        title: Text('iT\nServiços Itinerantes', textAlign: TextAlign.center),
        
      ),

      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 50),),
            TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                //border: OutlineInputBorder(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Adicione aqui a lógica da busca
                  },
                ),
              ),
            ),
            Expanded(child:
            Container(
              alignment: Alignment.center,
              child: Image(image: AssetImage('assets/image6.png'))
            ),
            ),

            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: 
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.grey[300], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      onPressed: () {
                        //ação do botão 1
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text('Login', style: TextStyle(color: Colors.black),),
                      ),
                    ),
                  ),
                  Expanded(child: 
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.grey[300], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      onPressed: () {
                        //ação do botão 2
                      },
                      child: Text('Cadastrar', style: TextStyle(color: Colors.black),),
              ),
            ),
            ),
                ],
              )
            ),
          ],
        ),
        
      ),
      
    );
  }
}
