import 'package:flutter_bloc/flutter_bloc.dart';
import '../dashboard_bloc.dart';
import 'package:feature_dashboard/src/l10n/l10n.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildLogo(context),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, size: 28),
            onPressed: () {
              context.read<DashboardBloc>().add(const DashboardEvent.qrScanPressed());
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, size: 28),
            onPressed: () {
              // TODO: Implement profile
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.water_drop, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          context.dashboardL10n.appName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
