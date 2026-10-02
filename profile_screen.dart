import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        title: const Text(
          'Wasifu Wangu',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),

      body: user == null
          ? const _NotLoggedInState()
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProfileHeader(user: user),

                    const SizedBox(height: 24),

                    _ProfileSection(
                      title: 'Taarifa za Akaunti',
                      children: [
                        _ProfileItem(
                          icon: Icons.email_outlined,
                          title: 'Barua pepe',
                          subtitle: user.email ?? 'Haijawekwa',
                        ),
                        _ProfileItem(
                          icon: Icons.phone_outlined,
                          title: 'Namba ya simu',
                          subtitle: user.phoneNumber ?? 'Haijawekwa',
                        ),
                        _ProfileItem(
                          icon: Icons.verified_user_outlined,
                          title: 'Hali ya akaunti',
                          subtitle: user.emailVerified
                              ? 'Barua pepe imethibitishwa'
                              : 'Barua pepe haijathibitishwa',
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _ProfileSection(
                      title: 'Mipangilio',
                      children: [
                        _ProfileItem(
                          icon: Icons.person_outline,
                          title: 'Hariri wasifu',
                          subtitle: 'Badilisha taarifa zako',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Sehemu ya kuhariri wasifu itaongezwa hivi karibuni.',
                                ),
                              ),
                            );
                          },
                        ),
                        _ProfileItem(
                          icon: Icons.location_on_outlined,
                          title: 'Anwani za delivery',
                          subtitle: 'Simamia anwani zako',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Sehemu ya anwani itaongezwa hivi karibuni.',
                                ),
                              ),
                            );
                          },
                        ),
                        _ProfileItem(
                          icon: Icons.notifications_outlined,
                          title: 'Arifa',
                          subtitle: 'Simamia arifa za app',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Mipangilio ya arifa itaongezwa hivi karibuni.',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _ProfileSection(
                      title: 'Msaada',
                      children: [
                        _ProfileItem(
                          icon: Icons.help_outline,
                          title: 'Msaada na Maswali',
                          subtitle: 'Pata msaada kuhusu Soko Letu Tz',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Sehemu ya msaada itaongezwa hivi karibuni.',
                                ),
                              ),
                            );
                          },
                        ),
                        _ProfileItem(
                          icon: Icons.info_outline,
                          title: 'Kuhusu Soko Letu Tz',
                          subtitle: 'Maelezo kuhusu app',
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: 'Soko Letu Tz',
                              applicationVersion: '1.0.0',
                              applicationLegalese:
                                  '© 2026 Soko Letu Tz',
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    FilledButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Toka kwenye akaunti',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(
                          double.infinity,
                          52,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Toka kwenye akaunti'),
          content: const Text(
            'Una uhakika unataka kutoka kwenye akaunti yako?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Ghairi'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Toka'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Umetoka kwenye akaunti.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imeshindikana kutoka: ${e.message ?? 'Jaribu tena.'}',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kuna tatizo limetokea. Tafadhali jaribu tena.',
          ),
        ),
      );
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final displayName = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : 'Mtumiaji wa Soko Letu';

    final email = user.email ?? 'Barua pepe haijawekwa';

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: theme.colorScheme.primary,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              child: user.photoURL == null
                  ? Text(
                      _getInitial(displayName),
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Akaunti hai',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitial(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return 'S';
    }

    return trimmedName.substring(0, 1).toUpperCase();
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 4,
            bottom: 10,
          ),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),

      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),

      subtitle: Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      trailing: onTap != null
          ? const Icon(
              Icons.chevron_right,
            )
          : null,

      onTap: onTap,
    );
  }
}

class _NotLoggedInState extends StatelessWidget {
  const _NotLoggedInState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: 20),

            Text(
              'Hujaingia kwenye akaunti',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Ingia kwenye akaunti yako ili kuona taarifa za wasifu wako.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tafadhali tumia ukurasa wa kuingia.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('Ingia'),
            ),
          ],
        ),
      ),
    );
  }
}
