// features/support/help_support_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../presentation/cubits/auth_cubits/auth_cubit.dart';
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
    final userEmail =
        authState is AuthAuthenticated ? authState.user.email : '';

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
                    answer:
                        'Tap the + button at the bottom center, then select "Expense" and fill in the details.',
                  ),
                  FaqItem(
                    question: 'How do I add income?',
                    answer:
                        'Tap the + button at the bottom center, then select "Income" and fill in the details.',
                  ),
                  FaqItem(
                    question: 'How to view my spending trends?',
                    answer:
                        'Go to the Flow tab to see your spending trends and cash flow analysis.',
                  ),
                  FaqItem(
                    question: 'Can I edit or delete a transaction?',
                    answer:
                        'Yes, go to Vault tab, tap on any transaction and select edit or delete.',
                  ),
                  FaqItem(
                    question: 'How does dark mode work?',
                    answer:
                        'Dark mode follows your system settings or you can toggle it from the drawer menu.',
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
                  Builder(
                    builder: (cardContext) => ContactCard(
                      icon: LucideIcons.share2,
                      title: 'Share with Friends',
                      subtitle: 'Help others manage money',
                      value: 'Share Now',
                      onTap: () => _shareApp(cardContext),
                    ),
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
    setState(() => _isLoading = true);
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Budgeto Support Request',
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'Could not launch $emailLaunchUri';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open email client'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startLiveChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live chat feature coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _openWebsite() async {
    setState(() => _isLoading = true);
    final Uri url = Uri.parse('https://www.budgeto.com');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch website'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _reportBug(String userEmail) {
    _sendEmail('bugs@budgeto.com');
  }

  void _requestFeature(String userEmail) {
    _sendEmail('features@budgeto.com');
  }

  void _rateApp() async {
    setState(() => _isLoading = true);
    final Uri url = Uri.parse('https://apps.apple.com/app/budgeto');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Silently fail or log
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _shareApp(BuildContext shareContext) {
    final RenderBox? box = shareContext.findRenderObject() as RenderBox?;
    final Rect? shareRect = box != null 
        ? box.localToGlobal(Offset.zero) & box.size 
        : null;

    Share.share(
      'Check out Budgeto - the smartest way to track your expenses! https://budgeto.com',
      subject: 'Manage your money better with Budgeto',
      sharePositionOrigin: shareRect,
    );
  }
}
