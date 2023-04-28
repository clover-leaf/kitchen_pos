// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchen_pos/home/home.dart';
import 'package:kitchen_pos/order/order.dart';
import 'package:kitchen_pos/rating/rating.dart';
import 'package:kitchen_pos/utils/show_notification.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc(
            clientRepository: context.read<ClientRepository>(),
          )..add(const SubscribeRobotReady()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => OrderBloc(
            clientRepository: context.read<ClientRepository>(),
          )..add(const StartOrder()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => RatingBloc(
            clientRepository: context.read<ClientRepository>(),
          )..add(const Start()),
        ),
      ],
      child: const HomeMediator(),
    );
  }
}

class HomeMediator extends StatelessWidget {
  const HomeMediator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShowRobotReadyNotify = context
        .select((HomeBloc bloc) => bloc.state.shouldShowRobotReadyNotify);
    final shouldShowRobotOnDutyNotify = context
        .select((HomeBloc bloc) => bloc.state.shouldShowRobotOnDutyNotify);
    final shouldShowRobotUnreadyNotify = context
        .select((HomeBloc bloc) => bloc.state.shouldShowRobotUnreadyNotify);

    return HomeView(
      shouldShowRobotReadyNotify: shouldShowRobotReadyNotify.value,
      shouldShowRobotOnDutyNotify: shouldShowRobotOnDutyNotify.value,
      shouldShowRobotUnreadyNotify: shouldShowRobotUnreadyNotify.value,
    );
  }
}

class HomeView extends StatefulWidget {
  HomeView({
    required this.shouldShowRobotReadyNotify,
    required this.shouldShowRobotOnDutyNotify,
    required this.shouldShowRobotUnreadyNotify,
    super.key,
  });

  final bool shouldShowRobotReadyNotify;
  final bool shouldShowRobotOnDutyNotify;
  final bool shouldShowRobotUnreadyNotify;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.shouldShowRobotReadyNotify) {
        buildSuccessNotification(
          title: 'Robot is ready',
          description: 'Robot is ready and start to deliver!',
        ).show(context);
      } else if (widget.shouldShowRobotOnDutyNotify) {
        buildErrorNotification(
          title: 'Robot is on duty',
          description: 'Robot can not start new deliver because it is on duty',
        ).show(context);
      } else if (widget.shouldShowRobotUnreadyNotify) {
        buildErrorNotification(
          title: 'Robot is not ready',
          description: 'Robot is not detect any food on it',
        ).show(context);
      }
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final selectTab = context.select((HomeBloc bloc) => bloc.state.tab);
    const orderPage = OrderView();
    const ratingPage = RatingView();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeNavbar(selectTab),
          Expanded(
            child: LazyLoadIndexedStack(
              index: selectTab.index,
              children: const [
                orderPage,
                ratingPage,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
