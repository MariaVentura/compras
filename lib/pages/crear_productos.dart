import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  int price;

  TextEditingController priceInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;

  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
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
        FlatButton(
          onPressed: () {
            captureImage(SelectSource.camara);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Row(
            children: <Widget>[Text('Camara'), Icon(Icons.camera)],
          ),
        ),
        FlatButton(
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
            .child('$name.jpg');
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
                    'image': urlFoto,
                    'price': price,
                  })
                  .then((value) => Navigator.of(context).pop())
                  .catchError(
                      (onError) => print('Error al registrar su produtos bd'));
              _isInAsyncCall = false;
            });
          });
        });
      } else {
        FirebaseFirestore.instance
            .collection('productos')
            .add({
              'name': name,
              'image': urlFoto,
              'price': price,
            })
            .then((value) => Navigator.of(context).pop())
            .catchError((onError) => print('Error al registrar su receta bd'));
        _isInAsyncCall = false;
      }
    } else {
      print('objeto no validado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Crear Productos',
          style: TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }
}
