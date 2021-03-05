import 'package:compras/models/productos_model.dart';
import 'package:compras/pages/otra_pagina.dart';
import 'package:compras/pages/pedido_lista.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'App Compras'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ProductosModel> _productosModel = List<ProductosModel>();
  List<ProductosModel> _listaCarro = List<ProductosModel>();

  @override
  void initState() {
    super.initState();
    _productosDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 38,
                  ),
                  if (_listaCarro.length > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Text(
                          _listaCarro.length.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.0),
                        ),
                      ),
                    )
                ],
              ),
              onTap: () {
                if (_listaCarro.isNotEmpty)
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Cart(_listaCarro),
                  ));
              },
            ),
          )
        ],
      ), //Título
      drawer: Container(
        //Menú izquierda
        width: 170.0,
        child: Drawer(
          child: Container(
            width: MediaQuery.of(context).size.width * 1.0, //0.5
            color: Colors.black,
            child: new ListView(
              padding: EdgeInsets.only(top: 50.0),
              children: <Widget>[
                Container(
                  height: 110,
                  child: new UserAccountsDrawerHeader(
                    accountName: new Text(''),
                    accountEmail: new Text(''),
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                            image: AssetImage(
                              'assets/images/logo.png',
                            ),
                            fit: BoxFit.fill)),
                  ),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: new Icon(
                    Icons.home,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => OtraPagina(),
                  )),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Cupones',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: new Icon(
                    Icons.card_giftcard,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => OtraPagina(),
                  )),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Tiendas',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: new Icon(
                    Icons.place,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => OtraPagina(),
                  )),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Productos',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: new Icon(
                    Icons.fastfood,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => OtraPagina(),
                  )),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'QR Code',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: new FaIcon(
                    FontAwesomeIcons.qrcode,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => OtraPagina(),
                  )),
                ),
                new Divider(),
              ],
            ),
          ),
        ),
      ),
      body: _cuadroProductos(),
    );
  }

  GridView _cuadroProductos() {
    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _productosModel.length,
      itemBuilder: (context, index) {
        final String image = _productosModel[index].image;
        var item = _productosModel[index];
        return Card(
            elevation: 4.0,
            child: Stack(
              fit: StackFit.loose,
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: new Image.asset("assets/images/$image",
                          fit: BoxFit.contain),
                    ),
                    Text(
                      item.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          item.price.toString(),
                          //textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 5.0,
                            bottom: 5.0,
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              child: (_listaCarro.contains(item))
                                  ? Icon(
                                      Icons.shopping_cart,
                                      color: Colors.green,
                                      size: 32,
                                    )
                                  : //De lo contrario
                                  Icon(
                                      Icons.shopping_cart,
                                      color: Colors.red,
                                      size: 32,
                                    ),
                              onTap: () {
                                setState(() {
                                  if (!_listaCarro.contains(item))
                                    _listaCarro.add(item);
                                  else
                                    _listaCarro.remove(item);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ));
      },
    );
  }

  void _productosDb() {
    var list = <ProductosModel>[
      ProductosModel(
        name: 'Burger King',
        image: 'food1.png',
        price: 12.00,
      ),
      ProductosModel(
        name: 'Pizza Hut',
        image: 'food2.png',
        price: 20.00,
      ),
      ProductosModel(
        name: 'KFC',
        image: 'food3.png',
        price: 39.90,
      ),
      ProductosModel(
        name: 'Domino\'s',
        image: 'food4.png',
        price: 29.90,
      ),
      ProductosModel(
        name: 'Sushi Roll',
        image: 'food5.png',
        price: 15.00,
      ),
      ProductosModel(
        name: 'Bembos',
        image: 'food6.png',
        price: 17.90,
      ),
      ProductosModel(
        name: 'Otto Grill',
        image: 'food7.png',
        price: 13.00,
      ),
      ProductosModel(
        name: 'Chilis',
        image: 'food8.png',
        price: 19.90,
      ),
    ];
    setState(() {
      _productosModel = list;
    });
  }
}
