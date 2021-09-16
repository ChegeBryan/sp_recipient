class BackendUrl {
  // change this to be from environment/constant id
  static const String baseUrl = 'https://spdb.000webhostapp.com';

  // auth URLs
  static const String login = baseUrl + '/auth/login.php';
  static const String register = baseUrl + '/auth/register.php';

  // donors url
  static const String getDonors = baseUrl + '/recipient/getDonors.php';
  static const String getDonor = baseUrl + '/recipient/getDonor.php';
  static const String saveDonor = baseUrl + '/recipient/saveDonor.php';
  static const String updateDonorChoice =
      baseUrl + '/recipient/updateDonorChoice.php';
  static const String deleteDonorChoice =
      baseUrl + '/recipient/deleteDonorChoice.php';
}
