import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/loading_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await AuthService.instance.login(email: _email.text, password: _password.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.school_rounded, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 18),
                const Text('TontonHub', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('Masuk ke layanan platform terpadu.', style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 26),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                        validator: (value) => value != null && value.contains('@') ? null : 'Email wajib valid',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          ),
                        ),
                        validator: (value) => value != null && value.length >= 6 ? null : 'Password minimal 6 karakter',
                      ),
                      const SizedBox(height: 18),
                      LoadingButton(label: 'Login', isLoading: _isLoading, icon: Icons.login, onPressed: _login),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                        child: const Text('Belum punya akun? Register'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
