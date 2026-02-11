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

class _LoginViewState extends State<_LoginView> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = View.of(context).viewInsets.bottom;
    if (bottomInset > 0) {
      // Keyboard is visible, scroll to bottom
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.authL10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo section
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: AuthAsset.image.splash.svg(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.appName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4A4A4A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Subtitle
                Center(
                  child: Text(
                    l10n.loginTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A4A4A),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Email field with label above
                Text(
                  l10n.emailLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 8),
                _emailField(l10n),
                const SizedBox(height: 24),

                // Password field with label above
                Text(
                  l10n.passwordLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 8),
                _passwordField(l10n),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      l10n.forgotPassword,
                      style: const TextStyle(
                        color: Color(0xFF1CBEDE),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Login button
                SizedBox(
                  height: 56,
                  child: _loginButton(l10n),
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
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFF0078BE), Color(0xFF1CBEDE)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: ElevatedButton(
            onPressed: state.isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    l10n.loginButton,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _emailField(AuthLocalizations l10n) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (prev, curr) =>
          prev.fieldError != curr.fieldError || prev.error != curr.error || prev.emailHistory != curr.emailHistory,
      builder: (context, state) {
        return Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return state.emailHistory;
            }
            return state.emailHistory.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            _emailController.text = selection;
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            // Sync with our controller
            if (_emailController.text != controller.text && _emailController.text.isEmpty) {
              _emailController.text = controller.text;
            }
            controller.addListener(() {
              _emailController.text = controller.text;
            });

            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: l10n.emailHint,
                hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                ),
                errorText: state.fieldError == 'email' ? state.error : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.emailRequired;
                }
                return null;
              },
              onFieldSubmitted: (value) {
                onFieldSubmitted();
              },
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 64, // horizontal padding * 2
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
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
            hintText: l10n.passwordHint,
            hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
            ),
            errorText: state.fieldError == 'password' ? state.error : null,
            suffixIcon: IconButton(
              icon: Icon(
                state.obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: const Color(0xFF999999),
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
