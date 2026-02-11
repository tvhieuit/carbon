import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'dashboard_bloc.dart';
import 'widget/calendar_widget.dart';
import 'widget/order_card.dart';

@RoutePage()
class DashboardPage extends StatelessWidget implements AutoRouteWrapper {
  const DashboardPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<DashboardBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'), // TODO: Use localization
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardBloc>().add(const DashboardEvent.pullRefresh());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CalendarWidget(
              onDateSelected: (selectedDate, focusedDate) {
                context.read<DashboardBloc>().add(
                  DashboardEvent.calendarDaySelected(selectedDate, focusedDate),
                );
              },
            ),
            const SizedBox(height: 16.0),
            _StoreFilter(),
            const SizedBox(height: 16.0),
            _StaffFilter(),
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
          hint: const Text('Select Store'),
          items: state.stores.map((store) {
            return DropdownMenuItem<String>(
              value: store.id,
              child: Text(store.name),
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
        if (state.staffs.isEmpty) {
          return const SizedBox.shrink();
        }
        return DropdownButtonFormField<String>(
          value: state.selectedStaffId,
          hint: const Text('Select Staff'),
          items: state.staffs.map((staff) {
            return DropdownMenuItem<String>(
              value: staff.id,
              child: Text(staff.name),
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
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.orders.isEmpty) {
          return const Center(child: Text('No orders found'));
        }

        // TODO: Implement grouping logic here or in BLoC
        return ListView.builder(
          itemCount: state.orders.length,
          itemBuilder: (context, index) {
            final order = state.orders[index];
            return OrderCard(order: order);
          },
        );
      },
    );
  }
}
