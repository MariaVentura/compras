import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class CommonThings {
  static Size size;
}

class CrearProductos extends StatefulWidget {
  final String id;

  const CrearProductos({this.id});

  @override
  _CrearProductosState createState() => _CrearProductosState();
}

enum SelectSource { camara, galeria }

class _CrearProductosState extends State<CrearProductos> {
  File _foto;
  String urlFoto;
  bool _isInAsyncCall = false;
  num price;

  TextEditingController priceInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;

  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String nameImage;
  String name;
  String uid;

  Future captureImage(SelectSource opcion) async {
    PickedFile image;
    final _picker = ImagePicker();

    opcion == SelectSource.camara
        ? image = await _picker.getImage(source: ImageSource.camera)
        : image = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _foto = File(image.path);
      } else {
        print('Imagen no seleccionada');
      }
    });
  }

  Future getImage() async {
    AlertDialog alerta = new AlertDialog(
      content: Text('Abrir con'),
      title: Text('Seleccione imagen'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            captureImage(SelectSource.camara);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Row(
            children: <Widget>[Text('Camara'), Icon(Icons.camera)],
          ),
        ),
        TextButton(
          onPressed: () {
            captureImage(SelectSource.galeria);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Row(
            children: <Widget>[Text('Galeria'), Icon(Icons.image)],
          ),
        )
      ],
    );
    showDialog(context: context, builder: (_) => alerta);
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }

  bool _validarlo() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _enviar() {
    if (_validarlo()) {
      setState(() {
        _isInAsyncCall = true;
      });

      if (_foto != null) {
        final Reference fireStoreRef = FirebaseStorage.instance
            .ref()
            .child('productos')
            .child('$nameImage.jpg');
        final UploadTask task = fireStoreRef.putFile(
            _foto, SettableMetadata(contentType: 'image/jpeg'));

        task.then((onValue) {
          onValue.ref.getDownloadURL().then((onValue) {
            setState(() {
              urlFoto = onValue.toString();
              FirebaseFirestore.instance
                  .collection('productos')
                  .add({
                    'name': name,
                    'nameImage': nameImage,
                    'image': urlFoto,
                    'price': price,
                  })
                  .then((value) => Navigator.of(context).pop())
                  .catchError(
                      (onError) => print('Error al registrar'));
              _isInAsyncCall = false;
            });
          });
        });
      } else {
        FirebaseFirestore.instance
            .collection('productos')
            .add({
              'name': name,
              'nameImage': nameImage,
              'image': urlFoto,
              'price': price,
            })
            .then((value) => Navigator.of(context).pop())
            .catchError((onError) => print('Error al registrar'));
        _isInAsyncCall = false;
      }
    } else {
      print('Objeto no validado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Producto'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.5,
          dismissible: false,
          progressIndicator: CircularProgressIndicator(),
          color: Colors.blueGrey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 10, right: 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                          onTap: getImage,
                        ),
                        margin: EdgeInsets.only(top: 20),
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.black),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: _foto == null
                                    ? AssetImage('assets/images/reloj.gif')
                                    : FileImage(_foto))),
                      )
                    ],
                  ),
                  Text('Click para cambiar foto'),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nombre Imagen',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, ingrese nombre Imagen';
                      }
                      return null;
                    },
                    onSaved: (value) => nameImage = value.trim(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                        hintText: 'Nombre',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, ingrese nombre';
                      }
                      return null;
                    },
                    onSaved: (value) => name = value.trim(),
                  ),
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Precio',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, ingrese precio';
                      }
                      return null;
                    },
                    onSaved: (value) => price = num.parse(value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        primary: Colors.green),
                        onPressed: _enviar,
                        child: Text('Crear',
                            style: TextStyle(color: Colors.white)),

                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}