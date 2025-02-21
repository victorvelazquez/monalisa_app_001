import 'package:flutter/material.dart';

import '../constants/roles_app.dart';

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

var appHomeOptionCol1Items = <MenuItem>[
  if (RolesApp.appShipment)
    const MenuItem(
      title: 'Shipment',
      subTitle: '',
      link: '/mInOut/shipment',
      icon: Icons.upload,
    ),
  if (RolesApp.appShipmentconfirm)
    const MenuItem(
      title: 'Shipment Confirm',
      subTitle: '',
      link: '/mInOut/shipmentconfirm',
      icon: Icons.upload,
    ),
  // MenuItem(
  //   title: 'PickUp /QA',
  //   subTitle: '',
  //   link: '/splash',
  //   icon: Icons.upload,
  // ),
];

var appHomeOptionCol2Items = <MenuItem>[
  if (RolesApp.appReceipt)
    const MenuItem(
      title: 'Receipt',
      subTitle: '',
      link: '/mInOut/receipt',
      icon: Icons.download,
    ),
  if (RolesApp.appReceiptconfirm)
    const MenuItem(
      title: 'Receipt Confirm',
      subTitle: '',
      link: '/mInOut/receiptconfirm',
      icon: Icons.download,
    ),
  // MenuItem(
  //   title: 'QA',
  //   subTitle: '',
  //   link: '/splash',
  //   icon: Icons.download,
  // ),
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
