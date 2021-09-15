import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:sp_recipient/services/backend.dart';

enum Status { Waiting, InProgress, Completed, Failed }

class DonorProvider with ChangeNotifier {
  Status _actionStatus = Status.Waiting;

  Status get actionStatus => _actionStatus;

  Future<Map<String, dynamic>> pickDonor(int donor) async {
    var result;

    final Map<String, dynamic> data = {'id': donor.toString()};

    _actionStatus = Status.InProgress;
    notifyListeners();

    Response res = await post(
      Uri.parse(BackendUrl.saveDonor),
      body: data,
    );

    final Map<String, dynamic> responseData = jsonDecode(res.body);

    if (!responseData['error']) {
      _actionStatus = Status.Completed;
      notifyListeners();
      result = {
        'status': true,
        'message': 'Successfully added picked a donor.'
      };
    } else {
      _actionStatus = Status.Failed;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Failed to pick a donor.',
        'error': responseData['data']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> getDonors() async {
    var result;

    Response res = await get(Uri.parse(BackendUrl.getDonors));

    final Map<String, dynamic> responseData = jsonDecode(res.body);

    if (!responseData['error']) {
      result = {'status': true, 'data': responseData['data']};
    } else {
      result = {'status': false, 'message': responseData['message']};
    }
    return result;
  }

  Future<Map<String, dynamic>> updateDonorChoice(
      int id, String name, String location) async {
    var result;

    final Map<String, dynamic> data = {
      'id': id.toString(),
    };

    _actionStatus = Status.InProgress;
    notifyListeners();

    Response res = await post(
      Uri.parse(BackendUrl.updateDonorChoice),
      body: data,
    );

    final Map<String, dynamic> responseData = jsonDecode(res.body);

    if (!responseData['error']) {
      _actionStatus = Status.Completed;
      notifyListeners();
      result = {
        'status': true,
        'message': 'Successfully updated donor choice.'
      };
    } else if (responseData['data'] != null) {
      _actionStatus = Status.Failed;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Failed to update donor choice.',
        'error': responseData['data']
      };
    } else {
      _actionStatus = Status.Failed;
      notifyListeners();
      result = {
        'status': false,
        'message': 'Failed to update donor choice.',
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> deleteDonorChoice(int id) async {
    var result;

    final Map<String, dynamic> data = {'id': id.toString()};

    Response res =
        await post(Uri.parse(BackendUrl.deleteDonorChoice), body: data);

    final Map<String, dynamic> responseData = jsonDecode(res.body);

    if (!responseData['error']) {
      result = {'status': true, 'message': 'Delete successful'};
    } else {
      result = {'status': false, 'message': 'Delete failed.'};
    }
    return result;
  }
}
