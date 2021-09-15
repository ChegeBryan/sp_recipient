import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_recipient/services/donors.dart';

class DonorScreen extends StatelessWidget {
  const DonorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donors'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Provider.of<DonorProvider>(context).getDonors(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!['status'] && snapshot.data!['data'].isEmpty) {
              return Center(
                child: Text('No donors available.'),
              );
            }
            if (!snapshot.data!['status']) {
              return Center(
                child: Text(snapshot.data!['message']),
              );
            }
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) => ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/donorDetails',
                    arguments: {
                      'donor_name': snapshot.data!['data'][index]['donor_name'],
                      'sperm_bank': snapshot.data!['data'][index]['sb_name'],
                      'donor_id': snapshot.data!['data'][index]['donor_id'],
                    },
                  );
                },
                leading: Icon(Icons.person),
                title: Text(snapshot.data!['data'][index]['donor_name']),
                subtitle: Text(
                  'Sperm Bank ' + snapshot.data!['data'][index]['sb_name'],
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/donorDetails',
                      arguments: {
                        'donor_name': snapshot.data!['data'][index]
                            ['donor_name'],
                        'sperm_bank': snapshot.data!['data'][index]['sb_name'],
                        'donor_id': snapshot.data!['data'][index]['donor_id'],
                      },
                    );
                  },
                  icon: Icon(Icons.keyboard_arrow_right),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: snapshot.data!['data'].length,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
