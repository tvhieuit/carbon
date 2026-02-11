import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:feature_dashboard/src/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'dashboard_bloc.dart';
import 'widget/dashboard_header.dart';
import 'widget/date_selector.dart';
import 'widget/delivery_table.dart';

@RoutePage()
class DashboardPage extends StatelessWidget implements AutoRouteWrapper {
  const DashboardPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<DashboardBloc>()..add(const DashboardEvent.started()),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const DashboardHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.dashboardL10n.deliveryList,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BlocBuilder<DashboardBloc, DashboardState>(
                        buildWhen: (p, c) => p.selectedDate != c.selectedDate,
                        builder: (context, state) {
                          return DateSelector(
                            selectedDate: state.selectedDate,
                            onPrevious: () {
                              final prevDate = state.selectedDate.subtract(const Duration(days: 1));
                              context.read<DashboardBloc>().add(
                                DashboardEvent.calendarDaySelected(prevDate, prevDate),
                              );
                            },
                            onNext: () {
                              final nextDate = state.selectedDate.add(const Duration(days: 1));
                              context.read<DashboardBloc>().add(
                                DashboardEvent.calendarDaySelected(nextDate, nextDate),
                              );
                            },
                            onTap: () {
                              // TODO: Show calendar picker or navigate back
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(child: _StoreFilter()),
                      const SizedBox(width: 12),
                      Expanded(child: _StaffFilter()),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Expanded(child: _OrderList()),
          ],
        ),
      ),
    );
  }
}

class _StoreFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (prev, curr) => prev.stores != curr.stores || prev.selectedStoreId != curr.selectedStoreId,
      builder: (context, state) {
        if (state.stores.isEmpty) {
          return const SizedBox.shrink();
        }
        return DropdownButtonFormField<String>(
          value: state.selectedStoreId,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            constraints: const BoxConstraints(maxHeight: 36),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
          ),
          isExpanded: true,
          isDense: true,
          hint: const Text(''),
          items: state.stores.map((store) {
            return DropdownMenuItem<String>(
              value: store.id,
              child: Text(
                store.name,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<DashboardBloc>().add(DashboardEvent.selectStore(value));
            }
          },
        );
      },
    );
  }
}

class _StaffFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (prev, curr) => prev.staffs != curr.staffs || prev.selectedStaffId != curr.selectedStaffId,
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          value: state.selectedStaffId,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            constraints: const BoxConstraints(maxHeight: 36),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
          ),
          isExpanded: true,
          isDense: true,
          hint: const Text(''),
          items: state.staffs.isEmpty
              ? [
                  DropdownMenuItem<String>(
                    value: null,
                    enabled: false,
                    child: Center(
                      child: Text(
                        context.dashboardL10n.noData,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ]
              : state.staffs.map((staff) {
                  return DropdownMenuItem<String>(
                    value: staff.id,
                    child: Text(
                      staff.name,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<DashboardBloc>().add(DashboardEvent.selectStaff(value));
            }
          },
        );
      },
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (prev, curr) => prev.orders != curr.orders || prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: DeliveryTable(orders: state.orders),
        );
      },
    );
  }
}
