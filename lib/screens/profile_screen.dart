
// lib/screens/profile_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor:
          theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Wasifu Wangu',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: user == null
          ? const _NotLoggedInState()
          : SafeArea(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  32,
                ),
                child: Column(
                  children: [
                    _ProfileHeader(
                      user: user,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const _SectionTitle(
                      title:
                          'Taarifa za Akaunti',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _ProfileTile(
                      icon: Icons
                          .email_outlined,
                      title:
                          'Barua pepe',
                      subtitle:
                          user.email ??
                              'Haijawekwa',
                    ),
                    _ProfileTile(
                      icon: Icons
                          .verified_user_outlined,
                      title:
                          'Hali ya akaunti',
                      subtitle: user
                              .emailVerified
                          ? 'Barua pepe imethibitishwa'
                          : 'Barua pepe haijathibitishwa',
                      trailing: Icon(
                        user.emailVerified
                            ? Icons
                                .verified_rounded
                            : Icons
                                .info_outline_rounded,
                        color: user
                                .emailVerified
                            ? theme
                                .colorScheme
                                .primary
                            : theme
                                .colorScheme
                                .onSurfaceVariant,
                      ),
                    ),
                    _ProfileTile(
                      icon: Icons
                          .phone_outlined,
                      title:
                          'Namba ya simu',
                      subtitle:
                          user.phoneNumber ??
                              'Haijawekwa',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const _SectionTitle(
                      title:
                          'Mipangilio ya Akaunti',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _ProfileTile(
                      icon: Icons
                          .person_outline_rounded,
                      title:
                          'Taarifa binafsi',
                      subtitle:
                          'Hariri taarifa zako',
                      onTap: () =>
                          _showComingSoon(
                        context,
                      ),
                    ),
                    _ProfileTile(
                      icon: Icons
                          .location_on_outlined,
                      title:
                          'Anwani za Delivery',
                      subtitle:
                          'Simamia anwani zako',
                      onTap: () =>
                          _showComingSoon(
                        context,
                      ),
                    ),
                    _ProfileTile(
                      icon: Icons
                          .receipt_long_outlined,
                      title:
                          'Maagizo yangu',
                      subtitle:
                          'Angalia historia ya manunuzi',
                      onTap: () =>
                          _showComingSoon(
                        context,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width:
                          double.infinity,
                      height: 52,
                      child:
                          OutlinedButton.icon(
                        onPressed: () {
                          _showSignOutDialog(
                            context,
                            ref,
                          );
                        },
                        icon: Icon(
                          Icons
                              .logout_rounded,
                          color: theme
                              .colorScheme
                              .error,
                        ),
                        label: Text(
                          'Toka kwenye Akaunti',
                          style: TextStyle(
                            color: theme
                                .colorScheme
                                .error,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                        style:
                            OutlinedButton
                                .styleFrom(
                          side: BorderSide(
                            color: theme
                                .colorScheme
                                .error
                                .withValues(
                              alpha: 0.5,
                            ),
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showSignOutDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Toka kwenye akaunti?',
            style: TextStyle(
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          content: const Text(
            'Utaondolewa kwenye akaunti yako ya SOKO LETU Tz.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child:
                  const Text('Ghairi'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(
                  dialogContext,
                ).pop();

                try {
                  final authService =
                      ref.read(
                    authServiceProvider,
                  );

                  await authService
                      .signOut();
                } catch (_) {
                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  )
                      .hideCurrentSnackBar();

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Imeshindikana kutoka kwenye akaunti.',
                      ),
                      behavior:
                          SnackBarBehavior
                              .floating,
                      backgroundColor:
                          Theme.of(context)
                              .colorScheme
                              .error,
                    ),
                  );
                }
              },
              child:
                  const Text('Toka'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Sehemu hii itaongezwa kwenye hatua inayofuata.',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }
}

class _ProfileHeader
    extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
  });

  final User user;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    final displayName =
        user.displayName
                    ?.trim()
                    .isNotEmpty ==
                true
            ? user.displayName!.trim()
            : 'Mteja wa SOKO LETU';

    final initial = displayName
        .substring(0, 1)
        .toUpperCase();

    final photoUrl =
        user.photoURL?.trim();

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(22),
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme
                .primaryContainer,
          ],
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor:
                Colors.white
                    .withValues(
              alpha: 0.18,
            ),
            backgroundImage:
                photoUrl != null &&
                        photoUrl.isNotEmpty
                    ? NetworkImage(
                        photoUrl,
                      )
                    : null,
            child: photoUrl ==
                        null ||
                    photoUrl.isEmpty
                ? Text(
                    initial,
                    style: theme
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  )
                : null,
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            displayName,
            textAlign:
                TextAlign.center,
            style: theme.textTheme
                .titleLarge
                ?.copyWith(
              color:
                  Colors.white,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            user.email ??
                'Mtumiaji',
            textAlign:
                TextAlign.center,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: theme.textTheme
                .bodyMedium
                ?.copyWith(
              color: Colors.white
                  .withValues(
                alpha: 0.88,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle
    extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Align(
      alignment:
          Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme
            .titleMedium
            ?.copyWith(
          fontWeight:
              FontWeight.w800,
        ),
      ),
    );
  }
}

class _ProfileTile
    extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 8,
      ),
      elevation: 0,
      color: theme.colorScheme
          .surfaceContainerLow,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        side: BorderSide(
          color: theme.colorScheme
              .outlineVariant,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets
                .symmetric(
          horizontal: 14,
          vertical: 4,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration:
              BoxDecoration(
            color: theme.colorScheme
                .primaryContainer,
            borderRadius:
                BorderRadius.circular(
              13,
            ),
          ),
          child: Icon(
            icon,
            color: theme
                .colorScheme
                .onPrimaryContainer,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme
              .titleSmall
              ?.copyWith(
            fontWeight:
                FontWeight.w800,
          ),
        ),
        subtitle: Padding(
          padding:
              const EdgeInsets.only(
            top: 3,
          ),
          child: Text(
            subtitle,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
          ),
        ),
        trailing: trailing ??
            (onTap != null
                ? const Icon(
                    Icons
                        .chevron_right_rounded,
                  )
                : null),
        onTap: onTap,
      ),
    );
  }
}

class _NotLoggedInState
    extends StatelessWidget {
  const _NotLoggedInState();

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration:
                  BoxDecoration(
                color: theme
                    .colorScheme
                    .primaryContainer,
                shape:
                    BoxShape.circle,
              ),
              child: Icon(
                Icons
                    .person_outline_rounded,
                size: 52,
                color: theme
                    .colorScheme
                    .onPrimaryContainer,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              'Hujaingia kwenye akaunti',
              textAlign:
                  TextAlign.center,
              style: theme.textTheme
                  .headlineSmall
                  ?.copyWith(
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Ingia ili kuona taarifa za akaunti yako.',
              textAlign:
                  TextAlign.center,
              style: theme.textTheme
                  .bodyMedium
                  ?.copyWith(
                color: theme
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
