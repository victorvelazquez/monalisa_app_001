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

const appHomeOptionCol1Items = <MenuItem>[
  MenuItem(
    title: 'Shipment',
    subTitle: '',
    link: '/shipment',
    icon: Icons.upload,
  ),
  MenuItem(
    title: 'PickUp /QA',
    subTitle: '',
    link: '/splash',
    icon: Icons.upload,
  ),
  MenuItem(
      title: 'Shipment Confirm',
      subTitle: '',
      link: '/splash',
      icon: Icons.upload),
];

const appHomeOptionCol2Items = <MenuItem>[
  MenuItem(
    title: 'Material Recept',
    subTitle: '',
    link: '/shipment',
    icon: Icons.download,
  ),
  MenuItem(
    title: 'QA',
    subTitle: '',
    link: '/splash',
    icon: Icons.download,
  ),
  MenuItem(
      title: 'Recept Confirm',
      subTitle: '',
      link: '/splash',
      icon: Icons.download),
];

const appHomeOptionCol3Items = <MenuItem>[
  MenuItem(
    title: 'Opción 1',
    subTitle: '',
    link: '/splash',
    icon: Icons.multiple_stop_outlined,
  ),
  MenuItem(
    title: 'Opción 2',
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
