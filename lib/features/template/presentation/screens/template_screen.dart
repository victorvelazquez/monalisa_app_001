import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemplateScreen extends StatelessWidget {
  const TemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //     onTap: () => FocusScope.of(context).unfocus(),
    //      //onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    //     child: Scaffold(
    //       appBar: AppBar(
    //         title: const Text('Template Title'),
    //       ),
    //       body: _TemplateView(),
    //     ));

    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
          title: const Text('Template Title'),
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
        body: _TemplateListView(),
        // body: _TemplateListBuilderView(),

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.plus_one),
        // ),

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'fab1',
              shape: const StadiumBorder(),
              onPressed: () {},
              child: const Icon(Icons.plus_one),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'fab2',
              onPressed: () {},
              child: const Icon(Icons.plus_one),
            ),
          ],
        ));
  }
}

class _TemplateListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List'),
                  subtitle: Text('Sub title List'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List 2'),
                  subtitle: Text('Sub title List 2'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List 3'),
                  subtitle: Text('Sub title List 3'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List'),
                  subtitle: Text('Sub title List'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List 2'),
                  subtitle: Text('Sub title List 2'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List 3'),
                  subtitle: Text('Sub title List 3'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List'),
                  subtitle: Text('Sub title List'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List 2'),
                  subtitle: Text('Sub title List 2'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List 3'),
                  subtitle: Text('Sub title List 3'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List'),
                  subtitle: Text('Sub title List'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List 2'),
                  subtitle: Text('Sub title List 2'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                ListTile(
                  leading:
                      Icon(Icons.check_box_outlined, color: colors.primary),
                  title: Text('Title List 3'),
                  subtitle: Text('Sub title List 3'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: colors.primary),
                  onTap: () {},
                ),
                Divider(),
                const SizedBox(height: 16),
              ],
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
      ),
    );
  }
}

// class _TemplateListBuilderView extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           children: [
//             Expanded(
//                 child: ListView.builder(
//               itemCount: 100,
//               itemBuilder: (BuildContext context, int index) {
//                 return Text('Indice: $index');
//               },
//             )),
//             Text('Pie de pantalla'),
//             Text('Pie de pantalla'),
//           ],
//         ),
//       ),
//     );
//   }
// }
