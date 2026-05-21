import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/loading_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _idPengguna = TextEditingController();
  final _minatKonten = TextEditingController();
  final _creatorCode = TextEditingController();
  String _role = AppConstants.roleStudent;
  bool _isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _idPengguna.dispose();
    _minatKonten.dispose();
    _creatorCode.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_role == AppConstants.roleCreator && !isCreatorCodeValid(_creatorCode.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kode creator salah.')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.register(
        name: _name.text,
        email: _email.text,
        password: _password.text,
        idPengguna: _idPengguna.text,
        minatKonten: _minatKonten.text,
        role: _role,
      );
      if (mounted) Navigator.pop(context);
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
      appBar: AppBar(title: const Text('Register Akun')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('Buat Akun TontonHub', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.person_outline)),
                    validator: (value) => value != null && value.trim().length >= 3 ? null : 'Nama minimal 3 karakter',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    validator: (value) => value != null && value.contains('@') ? null : 'Email wajib valid',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
                    validator: (value) => value != null && value.length >= 6 ? null : 'Password minimal 6 karakter',
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _role,
                    decoration: const InputDecoration(labelText: 'Role Pengguna', prefixIcon: Icon(Icons.verified_user_outlined)),
                    items: const [
                      DropdownMenuItem(value: AppConstants.roleStudent, child: Text('Subscriber')),
                      DropdownMenuItem(value: AppConstants.roleCreator, child: Text('Creator')),
                    ],
                    onChanged: (value) => setState(() => _role = value ?? AppConstants.roleStudent),
                  ),
                  const SizedBox(height: 12),
                  if (_role == AppConstants.roleCreator)
                    TextFormField(
                      controller: _creatorCode,
                      decoration: const InputDecoration(labelText: 'Kode Creator', prefixIcon: Icon(Icons.workspace_premium_outlined)),
                    ),
                  if (_role == AppConstants.roleCreator) const SizedBox(height: 12),
                  TextFormField(
                    controller: _idPengguna,
                    decoration: const InputDecoration(labelText: 'ID Pengguna', prefixIcon: Icon(Icons.badge_outlined)),
                    validator: (value) => value != null && value.trim().isNotEmpty ? null : 'ID pengguna wajib diisi',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _minatKonten,
                    decoration: const InputDecoration(labelText: 'Minat Konten', prefixIcon: Icon(Icons.apartment_outlined)),
                    validator: (value) => value != null && value.trim().isNotEmpty ? null : 'Minat konten wajib diisi',
                  ),
                  const SizedBox(height: 18),
                  LoadingButton(label: 'Register', isLoading: _isLoading, icon: Icons.person_add_alt_1, onPressed: _register),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
