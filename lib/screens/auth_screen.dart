// lib/screens/auth_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

class AuthScreen
    extends ConsumerStatefulWidget {
  const AuthScreen({
    super.key,
  });

  @override
  ConsumerState<AuthScreen>
      createState() =>
          _AuthScreenState();
}

class _AuthScreenState
    extends ConsumerState<AuthScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final _emailController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final _confirmPasswordController =
      TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword =
      true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController
        .dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    if (!_isLogin &&
        _passwordController.text !=
            _confirmPasswordController
                .text) {
      _showMessage(
        'Nenosiri mbili hazifanani.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService =
          ref.read(
        authServiceProvider,
      );

      if (_isLogin) {
        await authService
            .signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        await authService
            .signUpWithEmail(
          _emailController.text,
          _passwordController.text,
        );
      }

      if (!mounted) {
        return;
      }

      _showMessage(
        _isLogin
            ? 'Umeingia kwenye akaunti.'
            : 'Akaunti imeundwa kwa mafanikio.',
      );

      // AuthWrapper inasikiliza authStateChanges
      // na itabadilisha screen automatically.
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message =
          error.toString()
              .replaceFirst(
                'Exception: ',
                '',
              );

      _showMessage(
        message,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
        backgroundColor: isError
            ? Theme.of(context)
                .colorScheme
                .error
            : null,
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });

    _formKey.currentState
        ?.reset();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 480,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration:
                          BoxDecoration(
                        color: theme
                            .colorScheme
                            .primary,
                        borderRadius:
                            BorderRadius
                                .circular(
                          24,
                        ),
                      ),
                      child: const Icon(
                        Icons
                            .shopping_bag_rounded,
                        color:
                            Colors.white,
                        size: 44,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'SOKO LETU Tz',
                      style: theme
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                        fontWeight:
                            FontWeight.w900,
                        color: theme
                            .colorScheme
                            .primary,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      _isLogin
                          ? 'Ingia kwenye akaunti yako'
                          : 'Fungua akaunti yako',
                      textAlign:
                          TextAlign.center,
                      style: theme
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        color: theme
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment<bool>(
                          value: true,
                          label:
                              Text('Ingia'),
                          icon: Icon(
                            Icons
                                .login_rounded,
                          ),
                        ),
                        ButtonSegment<bool>(
                          value: false,
                          label:
                              Text('Jisajili'),
                          icon: Icon(
                            Icons
                                .person_add_alt_1_rounded,
                          ),
                        ),
                      ],
                      selected: {
                        _isLogin,
                      },
                      onSelectionChanged:
                          (selection) {
                        setState(() {
                          _isLogin =
                              selection
                                  .first;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller:
                          _emailController,
                      keyboardType:
                          TextInputType
                              .emailAddress,
                      textInputAction:
                          TextInputAction
                              .next,
                      enabled:
                          !_isLoading,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Barua pepe',
                        hintText:
                            'mfano@email.com',
                        prefixIcon:
                            Icon(
                          Icons
                              .email_outlined,
                        ),
                      ),
                      validator: (value) {
                        final email =
                            value?.trim() ??
                                '';

                        if (email.isEmpty) {
                          return 'Weka barua pepe.';
                        }

                        if (!email
                            .contains('@')) {
                          return 'Weka barua pepe sahihi.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      controller:
                          _passwordController,
                      obscureText:
                          _obscurePassword,
                      enabled:
                          !_isLoading,
                      textInputAction:
                          _isLogin
                              ? TextInputAction
                                  .done
                              : TextInputAction
                                  .next,
                      decoration:
                          InputDecoration(
                        labelText:
                            'Nenosiri',
                        prefixIcon:
                            const Icon(
                          Icons
                              .lock_outline_rounded,
                        ),
                        suffixIcon:
                            IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons
                                    .visibility_outlined
                                : Icons
                                    .visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.length <
                                6) {
                          return 'Nenosiri liwe na angalau herufi 6.';
                        }

                        return null;
                      },
                      onFieldSubmitted:
                          (_) {
                        if (_isLogin) {
                          _submit();
                        }
                      },
                    ),
                    if (!_isLogin) ...[
                      const SizedBox(
                        height: 14,
                      ),
                      TextFormField(
                        controller:
                            _confirmPasswordController,
                        obscureText:
                            _obscureConfirmPassword,
                        enabled:
                            !_isLoading,
                        decoration:
                            InputDecoration(
                          labelText:
                              'Thibitisha nenosiri',
                          prefixIcon:
                              const Icon(
                            Icons
                                .lock_reset_rounded,
                          ),
                          suffixIcon:
                              IconButton(
                            onPressed:
                                () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons
                                      .visibility_outlined
                                  : Icons
                                      .visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Thibitisha nenosiri.';
                          }

                          if (value !=
                              _passwordController
                                  .text) {
                            return 'Nenosiri hazifanani.';
                          }

                          return null;
                        },
                      ),
                    ],
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width:
                          double.infinity,
                      height: 54,
                      child:
                          FilledButton(
                        onPressed:
                            _isLoading
                                ? null
                                : _submit,
                        child:
                            _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth:
                                          2.5,
                                      color:
                                          Colors.white,
                                    ),
                                  )
                                : Text(
                                    _isLogin
                                        ? 'Endelea'
                                        : 'Fungua Akaunti',
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.w800,
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    OutlinedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                  _showMessage(
                                    'Usajili wa namba unakuja hivi karibuni.',
                                  );
                                },
                      child: const Text(
                        'Endelea na Namba ya Simu',
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                  _showMessage(
                                    'Guest mode itaongezwa kwenye hatua inayofuata.',
                                  );
                                },
                      child: const Text(
                        'Endelea kama Mgeni',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      onPressed:
                          _isLoading
                              ? null
                              : _toggleMode,
                      child: Text(
                        _isLogin
                            ? 'Huna akaunti? Jisajili'
                            : 'Una akaunti tayari? Ingia',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
