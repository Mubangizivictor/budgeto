// core/shared/widgets/export_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../../presentation/cubits/export_cubit/export_cubit.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ExportCubit, ExportState>(
      listener: (context, state) {
        if (state is ExportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report exported successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<ExportCubit>().reset();
        }
        if (state is ExportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Export failed: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
          context.read<ExportCubit>().reset();
        }
      },
      builder: (context, state) {
        final isLoading = state is ExportLoading;

        return Builder(
          builder: (buttonContext) {
            return Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: theme.colorScheme.surface,
              ),
              child: IconButton(
                icon: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : Icon(
                        LucideIcons.download,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                onPressed: isLoading ? null : () => _showDateRangePicker(buttonContext),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    // 1. Capture the origin IMMEDIATELY when the button is pressed
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    Rect? shareRect = box != null 
        ? box.localToGlobal(Offset.zero) & box.size 
        : null;
    
    // Safety check: iOS crashes if the rect is zero
    if (shareRect != null && (shareRect.width == 0 || shareRect.height == 0)) {
      shareRect = null;
    }

    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: DateTime(now.year, now.month, 1),
        end: now,
      ),
      helpText: 'Select export date range',
      saveText: 'Export',
    );

    if (picked == null) return;
    if (!context.mounted) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return;

    final endDate = DateTime(
      picked.end.year,
      picked.end.month,
      picked.end.day,
      23, 59, 59,
    );

    context.read<ExportCubit>().exportPdf(
          userId: authState.user.id,
          startDate: picked.start,
          endDate: endDate,
          userName: authState.user.fullName,
          userEmail: authState.user.email,
          sharePositionOrigin: shareRect,
        );
  }
}
