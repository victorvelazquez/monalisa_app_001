import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monalisa_app_001/config/config.dart';

class TemplateHomeScreen extends StatelessWidget {
  const TemplateHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Home'),
      ),
      body: _TemplateListView(),
    );
  }
}

class _TemplateListView extends StatelessWidget {
  @override
  Widget build(Object context) {
    return ListView.builder(
      itemCount: appTemplateMenuItems.length,
      itemBuilder: (BuildContext context, int index) {
        final templateMenuItem = appTemplateMenuItems[index];
        return _CustomListTitle(templateMenuItem: templateMenuItem);
      },
    );
  }
}

class _CustomListTitle extends StatelessWidget {
  const _CustomListTitle({
    required this.templateMenuItem,
  });

  final MenuItem templateMenuItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(templateMenuItem.icon, color: colors.primary),
      title: Text(templateMenuItem.title),
      subtitle: Text(templateMenuItem.subTitle),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: colors.primary),
      onTap: () {
        context.push(templateMenuItem.link);
      },
    );
  }
}
