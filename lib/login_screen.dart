import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {

   const LoginScreen({super.key});

   @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
       String errorMessage = "An error occurred.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided for that user.";
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog("An error occurred.");
    }
  }
    void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(                
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFFD8B4FE),
                              Color(0xFF937DC2),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 20,
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white],
                            ).createShader(bounds),
                            child: const Text(
                          'Welcome to',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ),
                      Positioned(
                        top: 85,
                        left: 20,
                        child: const Text(
                          'Medicontact App',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            ),
                          ),
                      ),
                    ],
                  ),
                   Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color:  Color(0xFF937DC2),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                     child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: "Username",
                            filled: true,
                            fillColor: const Color(0xFFD8B4FE).withAlpha((0.3 * 255).toInt()),
                            prefixIcon: const Icon(Icons.person, color: Color(0xFF937DC2)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none
                            )
                            ),
                      ),
                   ),
                  Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
                     child: TextField(
                       controller: _passwordController,
                       obscureText: true,
                       decoration: InputDecoration(
                           hintText: "Password",
                           filled: true,
                           fillColor: const Color(0xFFD8B4FE).withAlpha((0.3 * 255).toInt()),
                           prefixIcon: const Icon(Icons.lock, color: Color(0xFF937DC2)),
                           border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                             borderSide: BorderSide.none
                           )),
                     ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 20.0),
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                       TextButton(
                         onPressed: () {},
                         child: const Text(
                           'Forgot Password?',
                           style: TextStyle(
                             color: Color.fromARGB(255, 120, 119, 119),
                            ),
                         ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD8B4FE),
                          minimumSize: const Size(double.infinity, 50),
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Color.fromARGB(255, 120, 119, 119), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              ),
        ));
  }
}

