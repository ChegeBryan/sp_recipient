import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_recipient/models/user.dart';
import 'package:sp_recipient/services/donors.dart';
import 'package:sp_recipient/services/user.dart';

class DonorDetailsScreen extends StatefulWidget {
  const DonorDetailsScreen({Key? key}) : super(key: key);

  @override
  _DonorDetailsScreenState createState() => _DonorDetailsScreenState();
}

class _DonorDetailsScreenState extends State<DonorDetailsScreen> {
  Widget _calculateAge(String birthDate) {
    DateTime dob = DateTime.parse(birthDate);
    Duration dur = DateTime.now().difference(dob);
    String differenceInYears = (dur.inDays / 365).floor().toString();
    return Text(differenceInYears + ' years');
  }

  @override
  Widget build(BuildContext context) {
    DonorProvider donorProvider = Provider.of<DonorProvider>(context);
    final _args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Details'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: donorProvider.getDonor(_args['donor_id']),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!['status'] && snapshot.data!['data'].isEmpty) {
              return Center(
                child: Text('No profile found.'),
              );
            }
            if (!snapshot.data!['status']) {
              return Center(
                child: Text(snapshot.data!['message']),
              );
            }
            Map<String, dynamic> profile = snapshot.data!['data'];
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Name'),
                    subtitle: Text(profile['name']),
                  ),
                  ListTile(
                    leading: Icon(Icons.height),
                    title: Text('Height'),
                    subtitle: Text(profile['height'].toString() + ' M'),
                  ),
                  ListTile(
                    leading: Icon(Icons.fitness_center),
                    title: Text('Weight'),
                    subtitle: Text(profile['weight'].toString() + ' Kgs.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.event),
                    title: Text('Age'),
                    subtitle: _calculateAge(profile['birth_date']),
                  ),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text('Ethnicity'),
                    subtitle: Text(profile['ethnicity']),
                  ),
                  ListTile(
                    leading: Icon(Icons.visibility),
                    title: Text('Eye color'),
                    subtitle: Text(profile['eye_color']),
                  ),
                  ListTile(
                    leading: Icon(Icons.face),
                    title: Text('Hair color'),
                    subtitle: Text(profile['hair_color']),
                  ),
                  ListTile(
                    leading: Icon(Icons.face_outlined),
                    title: Text('Complexion'),
                    subtitle: Text(profile['complexion']),
                  ),
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text('Education'),
                    subtitle: Text(profile['education']),
                  ),
                  ListTile(
                    leading: Icon(Icons.bloodtype),
                    title: Text('Blood Type'),
                    subtitle: Text(profile['bloodtype'].toString()),
                  ),
                  ListTile(
                    leading: Icon(Icons.stars),
                    title: Text('Interests'),
                    subtitle: Text(profile['interests'].toString()),
                  ),
                  ListTile(
                    leading: Icon(Icons.golf_course),
                    title: Text('Hobbies'),
                    subtitle: Text(profile['hobbies'].toString()),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Sperm Bank'),
                    subtitle: Text(_args['sperm_bank']),
                    leading: Icon(Icons.local_hospital),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final Future<Map<String, dynamic>> pickDonor =
                            donorProvider.pickDonor(
                                _args['donor_id'], user.id!);

                        pickDonor.then(
                          (response) {
                            if (response['status']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Your choice was registered.'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/donors', (route) => false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('An error occrurred.'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                        );
                      },
                      child: Text(
                        'Pick Donor',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 12.0)),
                      ),
                    ),
                  ),
                ],
              ),
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
