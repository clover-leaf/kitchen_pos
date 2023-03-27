import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitchen_pos/gen/assets.gen.dart';
import 'package:kitchen_pos/gen/colors.gen.dart';
import 'package:kitchen_pos/home/home.dart';
import 'package:kitchen_pos/order/bloc/order_bloc.dart';
import 'package:window_manager/window_manager.dart';

class HomeNavbar extends StatelessWidget {
  const HomeNavbar(this.selectTab, {super.key});

  final HomeTab selectTab;

  @override
  Widget build(BuildContext context) {
    final prepareDishesNumber =
        context.select((OrderBloc bloc) => bloc.state.prepareDishesNumber);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        windowManager.startDragging();
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorName.blue100,
              Colors.white,
            ],
            stops: [0.1, 1],
          ),
        ),
        width: 196,
        child: Column(
          children: [
            const LogoText(),
            const KitchenText(),
            const NavbarLabel('TASKS'),
            NavbarButton(
              selectedTab: selectTab,
              tab: HomeTab.order,
              svgGenImage: Assets.images.icons.main,
              badgeNumber: prepareDishesNumber,
            ),
            const SizedBox(height: 16),
            const NavbarLabel('Statistic'),
          ],
        ),
      ),
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 0, 8),
          child: Text(
            'Clover Cafe',
            style: GoogleFonts.sriracha(
              fontSize: 24,
              color: ColorName.blue800,
              fontWeight: FontWeight.w800,
              height: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

class KitchenText extends StatelessWidget {
  const KitchenText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 0, 8),
          child: Text(
            'Kichen',
            style: TextStyle(
              fontSize: 16,
              color: ColorName.blue800,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class NavbarLabel extends StatelessWidget {
  const NavbarLabel(this.label, {super.key});

  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 0, 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: ColorName.text100,
            ),
          ),
        ),
      ],
    );
  }
}
