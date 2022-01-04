import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import '../providers/kolkvium.dart';

class KolokviumiListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Твоите колоквиуми"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 500,
                    color: Colors.amber,
                    child: AddKolkviumScreen(),
                  );
                },
              );
              ;
            },
          )
        ],
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<Kolokvium>(
                builder: (ctx, places, ch) => places.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: places.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Text(places.items[i].name),
                          subtitle: Text(places.items[i].date),
                          onTap: () {},
                        ),
                      ),
                child: Center(
                  child: const Text('Got no kolkviumi yet, start adding some!'),
                ),
              ),
      ),
    );
  }
}
