import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/parent_provider.dart';

class ChildrenListScreen extends StatelessWidget {
  const ChildrenListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parentProvider = Provider.of<ParentProvider>(context);
    final children = parentProvider.children;

    return Scaffold(
      appBar: AppBar(title: const Text("👧 Your Children")),
      body: ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(child.avatar)),
            title: Text(child.name),
            subtitle: Text("Level: ${child.readingLevel}"),
            onTap: () {
              Navigator.pushNamed(context, '/child_detail', arguments: child);
            },
          );
        },
      ),
    );
  }
}
