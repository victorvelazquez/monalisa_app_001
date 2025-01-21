import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem(
      {required this.title,
      required this.subTitle,
      required this.link,
      required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Menu 1',
    subTitle: '',
    link: '/splash',
    icon: Icons.pie_chart,
  ),
  MenuItem(
      title: 'Menu 2',
      subTitle: '',
      link: '/splash',
      icon: Icons.content_paste_outlined),
  MenuItem(
      title: 'Menu 3',
      subTitle: '',
      link: '/splash',
      icon: Icons.people_alt_outlined),
];

const appHomeOptionItems = <MenuItem>[
  MenuItem(
    title: 'Shipment',
    subTitle: '',
    link: '/shipment',
    icon: Icons.multiple_stop_outlined,
  ),
  MenuItem(
    title: 'Reportes',
    subTitle: '',
    link: '/splash',
    icon: Icons.pie_chart,
  ),
  MenuItem(
      title: 'Opción 3',
      subTitle: '',
      link: '/splash',
      icon: Icons.people_alt_outlined),
  MenuItem(
      title: 'Templates',
      subTitle: '',
      link: '/templateHome',
      icon: Icons.widgets),
];

const appTemplateMenuItems = <MenuItem>[
  MenuItem(
      title: 'Botones',
      subTitle: 'Varios Botones en Flutter',
      link: '/templateButtons',
      icon: Icons.smart_button_outlined),
  MenuItem(
      title: 'Tarjetas',
      subTitle: 'Un contenedor estilizado',
      link: '/templateCards',
      icon: Icons.credit_card),
];
