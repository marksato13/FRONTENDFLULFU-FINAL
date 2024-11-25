import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:fluflu/src/provider/users_provider.dart';
import 'package:fluflu/src/utils/my_snackbar.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientUpdateController {
  late BuildContext context;
  late Function refresh;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();
  XFile? pickedFile; // Cambiado a XFile para soportar null safety
  File? imageFile;

  late ProgressDialog _progressDialog; // Inicializado en init
  bool isEnable = true;

  late User user;

  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));

    print('TOKEN ENVIADO: ${user.sessionToken}');
    await usersProvider.init(context, sessionUser: user);

    nameController.text = user.name;
    lastnameController.text = user.lastname;
    phoneController.text = user.phone;
    refresh();
  }

  void update() async {
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text.trim();

    if (name.isEmpty || lastname.isEmpty || phone.isEmpty) {
      MySnackbar.show(context, 'Debes ingresar todos los campos', Colors.red); // Color agregado
      return;
    }

    _progressDialog.show(
      max: 100,
      msg: 'Espere un momento...',
      progressType: ProgressType.valuable,
    );

    User myUser = User(
      id: user.id,
      name: name,
      lastname: lastname,
      phone: phone,
      image: user.image,
    );

    Stream<dynamic>? stream = await usersProvider.update(myUser, imageFile!);
    if (stream != null) {
      stream.listen((res) async {
        _progressDialog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        Fluttertoast.showToast(msg: responseApi.message);

        if (responseApi.success) {
          user = (await usersProvider.getById(myUser.id))!;
          print('Usuario obtenido: ${user.toJson()}');
          _sharedPref.save('user', user.toJson());
          Navigator.pushNamedAndRemoveUntil(
              context, 'client/products/list', (route) => false);
        } else {
          isEnable = true;
        }
      });
    } else {
      _progressDialog.close();
      MySnackbar.show(context, 'Error al actualizar el perfil', Colors.red); // Color agregado
    }
  }


  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().pickImage(source: imageSource); // Usamos pickImage
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path); // Verificamos si es null
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        selectImage(ImageSource.gallery);
      },
      child: Text('GALERIA'),
    );

    Widget cameraButton = ElevatedButton(
      onPressed: () {
        selectImage(ImageSource.camera);
      },
      child: Text('CAMARA'),
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  void back() {
    Navigator.pop(context);
  }
}
