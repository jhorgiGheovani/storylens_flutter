// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storylens/data/main_repository.dart';

import 'package:storylens/provider/main_provider.dart';
import 'package:storylens/provider/states.dart';
import 'package:storylens/widgets/list_story_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.onLogout,
    required this.addStory,
    required this.onTapped,
  });

  final Function() onLogout;
  final Function() addStory;
  final Function(String) onTapped;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
        title: const Text(
          "Storylens",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'Logout':
                  widget.onLogout();
                  break;
              }
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black87,
            ),
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => widget.addStory(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildList() {
    return ChangeNotifierProxyProvider<void, MainProvider>(
      create: (_) => MainProvider(mainRepository: MainRepository()),
      update: (_, __, MainProvider? provider) {
        provider ??= MainProvider(mainRepository: MainRepository());
        provider.getStory();
        return provider;
      },
      child: Consumer<MainProvider>(builder: (context, provider, _) {
        if (provider.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          );
        } else if (provider.state == ResultState.hasData) {
          return ListView.builder(
              itemBuilder: (context, index) {
                var data = provider.story?.listStory[index];

                return ListStoryItem(
                    story: data,
                    onTapped: (String id) {
                      widget.onTapped(id);
                    });
              },
              itemCount: provider.story?.listStory.length);
        } else if (provider.state == ResultState.noData) {
          return Center(
              child: Material(
            child: Text(provider.message),
          ));
        } else if (provider.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      }),
    );
  }
}
