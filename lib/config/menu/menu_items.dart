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
    title: 'Opción 1',
    subTitle: '',
    link: '/splash',
    icon: Icons.pie_chart,
  ),
  MenuItem(
      title: 'Opción 2',
      subTitle: '',
      link: '/splash',
      icon: Icons.content_paste_outlined),
  MenuItem(
      title: 'Opción 3',
      subTitle: '',
      link: '/splash',
      icon: Icons.people_alt_outlined),
  MenuItem(
      title: 'Opción 4',
      subTitle: '',
      link: '/splash',
      icon: Icons.rocket_launch_outlined),
];
