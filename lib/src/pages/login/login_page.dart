import 'package:fluflu/src/pages/login/login_controller.dart';
import 'package:fluflu/src/utils/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LoginController _con = LoginController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPersistentFrameCallback((timestamp) {
      _con.init(context);  // Inicializa el controlador
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              //Cabecera(),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PieDePagina(),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Habiit(context),
                    _textFieldEmail(),
                    _textFieldPassword(),
                    _buttonLogin(),
                    _textDontHaveAccount(context),
                    _buttonSkipLogin(),  // Botón "Saltar" modificado
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textDontHaveAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta?',
          style: TextStyle(color: MyColors.primaryColor),
        ),
        SizedBox(width: 7),
        GestureDetector(
          onTap: _con.goToRegisterPage,
          child: Text(
            'Regístrate aquí',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _con.login,
        child: Text(
          'Ingresar',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return MyColors.primaryColor.withOpacity(0.7);
              }
              return MyColors.primaryColor;
            },
          ),
        ),
      ),
    );
  }


  // Botón "Saltar" para ingresar como invitado
  Widget _buttonSkipLogin() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 170, vertical: 10),
      child: ElevatedButton(
        onPressed: _con.loginAsGuest,  // Método para login como invitado
        child: Text(
          'Modo Invitado',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return MyColors.primaryColor.withOpacity(0.7);
              }
              return MyColors.primaryColor;
            },
          ),
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColors.primaryColoDark.withOpacity(0.8)),
          prefixIcon: Icon(
            Icons.lock,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo Electrónico',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColors.primaryColoDark.withOpacity(0.8)),
          prefixIcon: Icon(
            Icons.code_sharp,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget Cabecera() {
    const double heightWaveOne = 180;
    const double heightWaveTwo = 400;
    const Color colorWaveOne = Color(0xFFBDBCBC);
    const Color colorWaveTwo = Color(0xFF1C4786);

    return ClipPath(
      clipper: WaveClipperTwo(reverse: false),
      child: Container(
        height: heightWaveOne,
        color: colorWaveOne,
        child: ClipPath(
          clipper: WaveClipperTwo(reverse: true),
          child: Container(
            height: heightWaveTwo,
            color: colorWaveTwo,
          ),
        ),
      ),
    );
  }

  Widget PieDePagina() {
    const double heightWaveOne = 170;
    const double heightWaveTwo = 350;
    const Color colorWaveOne = Color(0xFF1C4786);
    const Color colorWaveTwo = Color(0xFF1C4786);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(3.14159),
      child: ClipPath(
        clipper: WaveClipperTwo(reverse: true),
        child: Container(
          height: heightWaveOne,
          color: colorWaveOne,
          child: ClipPath(
            clipper: WaveClipperTwo(reverse: false),
            child: Container(
              height: heightWaveTwo,
              color: colorWaveTwo,
            ),
          ),
        ),
      ),
    );
  }

  Widget _Habiit(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 120,
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Image.asset(
        'assets/img/NewLogo 1.png',
        width: 320,
        height: 320,
      ),
    );
  }
}
