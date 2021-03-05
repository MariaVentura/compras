import 'package:compras/models/productos_model.dart';
import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:fancy_dialog/FancyGif.dart';
import 'package:fancy_dialog/FancyTheme.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  final List<ProductosModel> _cart;

  Cart(this._cart);

  @override
  _CartState createState() => _CartState(this._cart);
}

class _CartState extends State<Cart> {
  _CartState(this._cart);

  final _scrollController = ScrollController();
  var _firstScroll = true;
  bool _enabled = false;

  List<ProductosModel> _cart;

  Container pagoTotal(List<ProductosModel> _cart) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(left: 120),
      height: 70,
      width: 400,
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          Text('TOTAL: \S/. ${valorTotal(_cart)}',
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black))
        ],
      ),
    );
  }

  String valorTotal(List<ProductosModel> listaProductos) {
    double total = 0.0;
    for (int i = 0; i < listaProductos.length; i++) {
      total = total + listaProductos[i].price * listaProductos[i].quantity;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.restaurant_menu),
            onPressed: null,
            color: Colors.white,
          )
        ],
        title: Text('DETALLE ',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); //Regresar
            setState(() {
              _cart.length;
            });
          },
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (_enabled && _firstScroll) {
              _scrollController
                  .jumpTo(_scrollController.position.pixels - details.delta.dy);
            }
          },
          onVerticalDragEnd: (_) {
            if (_enabled) _firstScroll = false;
          },
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _cart.length,
                itemBuilder: (context, index) {
                  final String imagen = _cart[index].image;
                  var item = _cart[index];
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                  width: 100,
                                  height: 100,
                                  child: new Image.asset(
                                      "assets/images/$imagen",
                                      fit: BoxFit.contain),
                                )),
                                Column(
                                  children: <Widget>[
                                    Text(item.name,
                                        style: new TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 120,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.red[600],
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 6.0,
                                                  color: Colors.grey[400],
                                                  offset: Offset(0.0, 1.0),
                                                )
                                              ],
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              )),
                                          margin: EdgeInsets.only(top: 20.0),
                                          padding: EdgeInsets.all(2.0),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 8.0,
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  _removeProduct(index);
                                                  valorTotal(_cart);
                                                },
                                                color: Colors.white,
                                              ),
                                              Text(
                                                '${_cart[index].quantity}',
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19.0,
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  _addProduct(index);
                                                  valorTotal(_cart);
                                                },
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                height: 8.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 38.0,
                                ),
                                Text(item.price.toString(),
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                      color: Colors.black,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[600],
                      )
                    ],
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              pagoTotal(_cart),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 100,
                width: 200,
                padding: EdgeInsets.only(top: 50),
                child: RaisedButton(
                  child: Text('Pagar'),
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => FancyDialog(
                              title: "Proceder con la compra",
                              descreption: "descripción",
                              animationType: FancyAnimation.BOTTOM_TOP,
                              theme: FancyTheme.FANCY,
                              gifPath: FancyGif.MOVE_FORWARD,
                              okFun: () => {print('Cargando')},
                            )),
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                ),
              )
            ],
          ))),
    );
  }

  _addProduct(int index) {
    setState(() {
      _cart[index].quantity++;
    });
  }

  _removeProduct(int index) {
    if (_cart[index].quantity != 0) {
      setState(() {
        _cart[index].quantity--;
      });
    }
  }
}
