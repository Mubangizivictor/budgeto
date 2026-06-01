// features/support/presentation/screens/help_support_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../auth/presentation/widgets/back_button.dart';
import '../auth/presentation/widgets/loading_overlay.dart';
import 'contact_card.dart';
import 'faq_item.dart';
import 'help_section.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.watch<AuthCubit>().state;
    final userEmail = authState is AuthAuthenticated
        ? authState.user.email
        : '';

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Help & Support'),
          centerTitle: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: const CustomBackButton(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FAQ Section
              HelpSection(
                title: 'Frequently Asked Questions',
                icon: LucideIcons.messageCircle,
                children: const [
                  FaqItem(
                    question: 'How do I add an expense?',
                    answer: 'Tap the + button at the bottom center, then select "Expense" and fill in the details.',
                  ),
                  FaqItem(
                    question: 'How do I add income?',
                    answer: 'Tap the + button at the bottom center, then select "Income" and fill in the details.',
                  ),
                  FaqItem(
                    question: 'How to view my spending trends?',
                    answer: 'Go to the Flow tab to see your spending trends and cash flow analysis.',
                  ),
                  FaqItem(
                    question: 'Can I edit or delete a transaction?',
                    answer: 'Yes, go to Vault tab, tap on any transaction and select edit or delete.',
                  ),
                  FaqItem(
                    question: 'How does dark mode work?',
                    answer: 'Dark mode follows your system settings or you can toggle it from the drawer menu.',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Contact Section
              HelpSection(
                title: 'Contact Us',
                icon: LucideIcons.mail,
                children: [
                  ContactCard(
                    icon: LucideIcons.mail,
                    title: 'Email Support',
                    subtitle: 'We\'ll respond within 24 hours',
                    value: 'support@budgeto.com',
                    onTap: () => _sendEmail('support@budgeto.com'),
                  ),
                  const SizedBox(height: 12),
                  ContactCard(
                    icon: LucideIcons.messageSquare,
                    title: 'Live Chat',
                    subtitle: 'Available 9AM - 6PM',
                    value: 'Start Chat',
                    onTap: () => _startLiveChat(),
                  ),
                  const SizedBox(height: 12),
                  ContactCard(
                    icon: LucideIcons.globe,
                    title: 'Website',
                    subtitle: 'Visit our website',
                    value: 'www.budgeto.com',
                    onTap: () => _openWebsite(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Report Issue Section
              HelpSection(
                title: 'Report an Issue',
                icon: LucideIcons.alertTriangle,
                children: [
                  ContactCard(
                    icon: LucideIcons.bug,
                    title: 'Report a Bug',
                    subtitle: 'Help us improve',
                    value: 'Report Now',
                    onTap: () => _reportBug(userEmail),
                  ),
                  const SizedBox(height: 12),
                  ContactCard(
                    icon: LucideIcons.thumbsUp,
                    title: 'Feature Request',
                    subtitle: 'Suggest a feature',
                    value: 'Suggest Now',
                    onTap: () => _requestFeature(userEmail),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Rate App Section
              HelpSection(
                title: 'Love Budgeto?',
                icon: LucideIcons.heart,
                children: [
                  ContactCard(
                    icon: LucideIcons.star,
                    title: 'Rate us on App Store',
                    subtitle: 'Your rating helps us grow',
                    value: 'Rate Now',
                    onTap: () => _rateApp(),
                  ),
                  const SizedBox(height: 12),
                  ContactCard(
                    icon: LucideIcons.share2,
                    title: 'Share with Friends',
                    subtitle: 'Help others manage money',
                    value: 'Share Now',
                    onTap: () => _shareApp(),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _sendEmail(String email) async {
    // TODO: Implement email intent
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening email client to $email'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _startLiveChat() {
    // TODO: Implement live chat
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live chat feature coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _openWebsite() {
    // TODO: Implement URL launcher
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening website...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _reportBug(String userEmail) {
    // TODO: Implement bug reporting
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report bug feature coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _requestFeature(String userEmail) {
    // TODO: Implement feature request
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feature request feature coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _rateApp() {
    // TODO: Implement app rating
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for rating!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareApp() {
    // TODO: Implement share
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share feature coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}