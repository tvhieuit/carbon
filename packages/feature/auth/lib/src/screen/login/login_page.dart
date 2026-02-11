import 'package:auto_route/auto_route.dart';
import 'package:feature_auth/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'login_bloc.dart';
import '../../l10n/l10n.dart';

/// Login page
@RoutePage()
class LoginPage extends StatelessWidget implements AutoRouteWrapper {
  const LoginPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<LoginBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _LoginView();
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.authL10n;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or Title
                AuthAsset.image.splash.svg(
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 32),

                // Email field
                _emailField(l10n),
                const SizedBox(height: 16),

                // Password field
                _passwordField(l10n),
                const SizedBox(height: 8),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: Text(l10n.forgotPassword),
                  ),
                ),
                const SizedBox(height: 24),

                // Login button
                SizedBox(height: 50, child: _loginButton(l10n)),
                const SizedBox(height: 24),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.noAccount),
                    TextButton(
                      onPressed: _register,
                      child: Text(l10n.registerButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(AuthLocalizations l10n) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isLoading ? null : _login,
          child: state.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(l10n.loginButton),
        );
      },
    );
  }

  Widget _emailField(AuthLocalizations l10n) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (prev, curr) => prev.fieldError != curr.fieldError || prev.error != curr.error,
      builder: (context, state) {
        return TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.emailLabel,
            hintText: l10n.emailHint,
            prefixIcon: const Icon(Icons.email_outlined),
            border: const OutlineInputBorder(),
            errorText: state.fieldError == 'email' ? state.error : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.emailRequired;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _passwordField(AuthLocalizations l10n) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (prev, curr) =>
          prev.fieldError != curr.fieldError ||
          prev.error != curr.error ||
          prev.obscurePassword != curr.obscurePassword,
      builder: (context, state) {
        return TextFormField(
          controller: _passwordController,
          obscureText: state.obscurePassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: l10n.passwordLabel,
            hintText: l10n.passwordHint,
            prefixIcon: const Icon(Icons.lock_outline),
            border: const OutlineInputBorder(),
            errorText: state.fieldError == 'password' ? state.error : null,
            suffixIcon: IconButton(
              icon: Icon(
                state.obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
              onPressed: _obscurePasswordToggle,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.passwordRequired;
            }
            return null;
          },
          onFieldSubmitted: (_) => _login(),
        );
      },
    );
  }

  void _register() {
    context.read<LoginBloc>().add(const LoginEvent.register());
  }

  void _forgotPassword() {
    context.read<LoginBloc>().add(const LoginEvent.forgotPassword());
  }

  void _obscurePasswordToggle() {
    context.read<LoginBloc>().add(const LoginEvent.obscurePasswordToggle());
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(
        LoginEvent.submit(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }
}
