import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/config.dart';
import '../../../shared/shared.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/organization.dart';
import '../../domain/entities/role.dart';
import '../../domain/entities/warehouse.dart';
import '../providers/auth_provider.dart';

class AuthDataScreen extends StatelessWidget {
  const AuthDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Seleccionar Rol'),
          ),
          body: _RoleView(),
        ));
  }
}

class _RoleView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authDataState = ref.watch(authProvider);
    final authDataNotifier = ref.read(authProvider.notifier);

    return ListView(
      children: [
        const SizedBox(height: 16),
        _BuildDropdown<Client>(
          label: 'Grupo Empresarial',
          value: authDataState.selectedClient,
          options: authDataState.clients,
          onChanged: (client) => authDataNotifier.updateClient(client!),
        ),
        const SizedBox(height: 16),
        _BuildDropdown<Role>(
          label: 'Rol',
          value: authDataState.selectedRole,
          options: authDataState.roles,
          onChanged: (role) => authDataNotifier.updateRole(role!),
        ),
        const SizedBox(height: 16),
        _BuildDropdown<Organization>(
          label: 'Organización',
          value: authDataState.selectedOrganization,
          options: authDataState.organizations,
          onChanged: (organizations) =>
              authDataNotifier.updateOrganization(organizations!),
        ),
        const SizedBox(height: 16),
        _BuildDropdown<Warehouse>(
          label: 'Almacén',
          value: authDataState.selectedWarehouse,
          options: authDataState.warehouses,
          onChanged: (warehouse) =>
              authDataNotifier.updateWarehouse(warehouse!),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            spacing: 10,
            alignment: WrapAlignment.end,
            children: [
              CustomFilledButton(
                onPressed: authDataState.isLoading
                    ? null
                    : () {
                        authDataNotifier.submitAuthData();
                      },
                text: 'Confirmar',
                icon: Icon(Icons.check),
                textColor: Colors.white,
                buttonColor: colorSeed,
              ),
              CustomFilledButton(
                onPressed: () {
                  authDataNotifier.authDataCancelar(context);
                },
                text: 'Cancelar',
                icon: Icon(Icons.cancel),
                textColor: Colors.white,
                buttonColor: cancelButtonColor,
              )
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}

class _BuildDropdown<T> extends ConsumerWidget {
  final String label;
  final T? value;
  final List<T> options;
  final ValueChanged<T?> onChanged;

  const _BuildDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          DropdownButtonFormField<T>(
            value: value,
            items: options
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: size.width - 80),
                        child: Text(
                          option is Client
                              ? option.name
                              : option is Role
                                  ? option.name
                                  : option is Organization
                                      ? option.name
                                      : (option as Warehouse).name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          )
        ]));
  }
}
