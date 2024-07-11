// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final mainProvider = context.read<MainProvider>();
    scrollController.addListener(() {
      //cek kodisi kalau scroll udah sampai ujung
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        //cek kalau page item masih ada
        if (mainProvider.pageItems != null) {
          mainProvider
              .getStory(); //kalau scroll udah sampai ujung dan page item masih ada maka fetch api lagi
        }
      }
    });
    Future.microtask(() async => mainProvider.getStory());
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Trigger API call or refresh when the app is resumed
      final mainProvider = context.read<MainProvider>();
      // mainProvider.getStory();
      // mainProvider.stories.clear();
      mainProvider.pageItems = 1;
      Future.microtask(() async => mainProvider.getStory());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.black,
        shadowColor: Colors.grey,
        title: const Text(
          "Storylens",
          style: TextStyle(color: Colors.white),
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
              color: Colors.white,
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
        backgroundColor: Colors.blue.shade500,
        onPressed: () => widget.addStory(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildList() {
    return Consumer<MainProvider>(builder: (context, provider, child) {
      final stories = provider.stories;
      if (provider.state == ResultState.loading) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        );
      } else if (provider.state == ResultState.hasData) {
        return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index == stories.length && provider.pageItems != null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final storyItem = stories[index];

              return ListStoryItem(
                  story: storyItem,
                  onTapped: (String id) {
                    widget.onTapped(id);
                  });
            },
            // ignore: unnecessary_null_comparison
            itemCount: stories.length + (provider.pageItems != null ? 1 : 0));
      } else {
        return Center(
          child: Material(
            child: Text(provider.message),
          ),
        );
      }
    });
  }
}
