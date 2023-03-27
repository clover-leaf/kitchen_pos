// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:client_repository/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchen_pos/home/home.dart';
import 'package:kitchen_pos/order/order.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => OrderBloc(
            clientRepository: context.read<ClientRepository>(),
          )..add(const StartOrder()),
        ),
      ],
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectTab = context.select((HomeCubit cubit) => cubit.state.tab);
    const orderPage = OrderView();

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
              children: const [orderPage],
            ),
          ),
        ],
      ),
    );
  }
}
