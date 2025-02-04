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
      title: 'Cambiar Rol',
      subTitle: '',
      link: '/authData',
      icon: Icons.assignment_ind_rounded),
  MenuItem(
      title: 'Cerrar Sesión',
      subTitle: '',
      link: '/logout',
      icon: Icons.logout_outlined),
];

const appHomeOptionItems = <MenuItem>[
  MenuItem(
    title: 'Shipment Shipment',
    subTitle: '',
    link: '/shipment',
    icon: Icons.multiple_stop_outlined,
  ),
  MenuItem(
    title: 'Reportes Reportes',
    subTitle: '',
    link: '/splash',
    icon: Icons.pie_chart,
  ),
  MenuItem(
      title: 'Opción 3',
      subTitle: '',
      link: '/splash',
      icon: Icons.people_alt_outlined),
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
