import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../characters/presentation/bloc/characters_bloc.dart';

class HousesPage extends StatelessWidget {
  const HousesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final houses = const ['gryffindor', 'slytherin', 'ravenclaw', 'hufflepuff'];
    return Scaffold(
      appBar: AppBar(title: Text('houses_title'.tr())),
      body: ListView.builder(
        itemCount: houses.length,
        itemBuilder: (context, index) {
          final house = houses[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.shield),
              title: Text('house_${house}'.tr()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.read<CharactersBloc>().add(
                  LoadCharactersByHouse(house),
                );
                context.go('/');
              },
            ),
          );
        },
      ),
    );
  }
}
