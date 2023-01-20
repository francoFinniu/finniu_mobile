import 'package:finniu/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              // padding: EdgeInsets.all(6),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(primary_dark),
              ),
              child: Center(
                  child: Icon(
                size: 20,
                color: Color(primary_light),
                Icons.arrow_back_ios_new_outlined,
              )),
              // child: GestureDetector(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
            ),
          )),
      body: Center(
        // padding: EdgeInsets.all(10),
        // margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: 224,
              height: 143,
              child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/images/logo_finniu_light.png",
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: Text('¡Bienvenido a Finniu!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Color(primary_dark),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ))),
            ),
            SizedBox(height: 30),
            Container(
              width: 224,
              // height: 150,
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('Ingresa a tu cuenta',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          color: Color(blacktext),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ))),
                  ),
                  SizedBox(height: 30),
                  Container(
                      width: 224,
                      height: 38,
                      child: TextField(
                        onChanged: (value) {
                          var email = value;
                        },
                        decoration: InputDecoration(
                            label: Text(
                              "Correo electronico",
                              style: TextStyle(color: Colors.black),
                            ),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: const Color(primary_dark))),
                            isDense: true,
                            enabled: false),
                        controller: TextEditingController(text: "some Text"),
                      )),
                  SizedBox(height: 29),
                  Container(
                      width: 224,
                      height: 38,
                      child: TextField(
                        onChanged: (value) {
                          var email = value;
                        },
                        decoration: InputDecoration(
                            label: Text(
                              "Contraseña",
                              style: TextStyle(color: Colors.black),
                            ),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: const Color(primary_dark))),
                            isDense: true,
                            enabled: false),
                        controller: TextEditingController(text: "some Text"),
                      )),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login_email');
                    },
                    child: Container(
                      // padding: EdgeInsets.all(5),
                      // width: 230,
                      // height: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(primary_dark),
                      ),
                      child: Center(
                        child: Text('Ingresar',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Color(whitetext),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
