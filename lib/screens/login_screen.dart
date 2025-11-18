import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _loading = false;
  String _error = "";

  void _submit() async {
    setState(() {
      _loading = true;
      _error = "";
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final ok = await _authService.login(email, password);

    setState(() {
      _loading = false;
    });

    if (ok) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      setState(() {
        _error = 'Falha no login. Verifique email/senha.';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  "Rewind",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value != null && value.contains('@')
                      ? null
                      : 'Email inválido',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value != null && value.length >= 6
                      ? null
                      : 'Senha curta demais',
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 2),
                const SizedBox(height: 2),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          minimumSize: const Size(double.infinity, 45),

                        ),
                        child: _loading ? const CircularProgressIndicator() : const Text('Entrar',style: TextStyle(color: Colors.black)),
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Novo por aqui? Crie sua conta",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                _error != "" ? Text(
                    _error,
                    style: TextStyle(color: Colors.white)) : Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
