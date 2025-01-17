import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monalisa_app_001/features/template/presentation/widgets/template_custom_button.dart';

class TemplateButtonsScreen extends StatelessWidget {
  const TemplateButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Template Buttons'),
          actions: [
            IconButton(icon: Icon(Icons.refresh), onPressed: () {}),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                  child:
                      IconButton(icon: Icon(Icons.person), onPressed: () {})),
            ),
          ],
        ),
        body: _ButtonsView(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'fab1',
              shape: const StadiumBorder(),
              child: const Icon(Icons.plus_one),
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'fab2',
              child: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ));
  }
}

class _ButtonsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
                ElevatedButton(
                    onPressed: null, child: const Text('Elevated Disabled')),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.access_alarm_rounded),
                    label: const Text('Elevated Icon')),
                FilledButton(onPressed: () {}, child: const Text('Filled')),
                FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Filled Icon')),
                OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
                OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    label: const Text('Outlined Icon')),
                TextButton(onPressed: () {}, child: const Text('Text Button')),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    label: const Text('Text Button Icon')),
                IconButton(onPressed: () {}, icon: Icon(Icons.ac_unit)),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.ac_unit),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(colors.primary),
                    iconColor: const WidgetStatePropertyAll(Colors.white),
                  ),
                ),
                TemplateCustomButton(),
              ],
            ),
          ),
        ),
        Divider(),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Texto',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.green)),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text('Texto en Container',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'https://static1.howtogeekimages.com/wordpress/wp-content/uploads/2024/08/google-imagen-3-image-to-text-prompt-example.jpg',
                      width: size.width * 0.7,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Texto'),
                  Text('Fin...'),
                ],
              ),
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            color: colors.secondary,
            child: Column(
              children: [
                Text('Pie de pantalla'),
                Text('Pie de pantalla'),
              ],
            ),
          ),
      ],
    );
  }
}
