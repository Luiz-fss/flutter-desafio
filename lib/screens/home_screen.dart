import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_desafio/google_sign_in.dart';
import 'package:flutter_desafio/screens/login_screen.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final ScaffoldState _scaffoldState = ScaffoldState();


  void _showAlert(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Sair do aplicativo"),
            content: Text("Tem certeza que deseja sair ?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Sim",
                ),
                textColor: Colors.green,
                onPressed: (){
                  signOutGoogle();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context)=>LoginScreen()
                      )
                  );
                },
              ),
              FlatButton(
                child: Text("Não"),
                color: Colors.red,
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }


  Map<String,dynamic> _list={};
  Future _listMeals() async{
    //url de requisição
    String url = "https://www.themealdb.com/api/json/v1/1/search.php?f=a";

    /*variavel do tipo Response para receber a resposta e fazer a requisição
    * Requisição get: Recupera dados do servidor */
    http.Response response;
    response = await http.get(url);
    Map<String,dynamic> meal = json.decode(response.body);
    print(meal);
    setState(() {
      //_list=meal;
      _list.addAll(meal);
    });
    //print(_list["meals"][0]["strMeal"]);
    //print(_list);
    //print(meal);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listMeals();
  }

  int i=0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: Text("Refeições"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Colors.black,),
            onPressed: (){
              _showAlert();
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {

            return GestureDetector(
              onTap: (){},
              child: ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  child: Image.network(_list["meals"][index]["strMealThumb"],fit: BoxFit.cover,),
                ),
                title: Text(
                    _list["meals"][index]["strMeal"]
                ),
                subtitle: Text(
                  _list["meals"][index]["strCategory"],
                ),

              ),
            );

          }

      ),

    );
  }
}
