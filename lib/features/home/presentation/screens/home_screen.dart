import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monalisa_app_001/config/config.dart';
import 'package:monalisa_app_001/features/shared/shared.dart';

import '../../../shared/presentation/widgets/side_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Opciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: appHomeOptionItems.length,
          itemBuilder: (context, index) {
            final menuHomeOption = appHomeOptionItems[index];
            return HomeOption(
              title: menuHomeOption.title,
              icon: menuHomeOption.icon,
              onTap: () {
                  context.push(menuHomeOption.link);
              },
            );
          },
        ),
      ),
    );
  }
}
