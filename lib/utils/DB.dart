import 'package:finalproject1/models/User.dart';
// import 'package:mysql1/mysql1.dart';

var _conn;


/*
Future<void> connectToDB() async {
  var settings = new ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'ahmad12'
  );
  _conn = await MySqlConnection.connect(settings);
}




Future<void> showUsers() async {

  connectToDB();

  // Query the database using a parameterized query
  var results = await _conn.query(
    'select * from users',);
  for (var row in results) {
    print('userID: ${row[0]}, firstName: ${row[1]} Email: ${row[2]}');
  }
}






Future<void> insertUser( User user) async {

  connectToDB();

  var result = await _conn.query(
      'insert into users (firstName, Email, lastName) values (?, ?, ?)',
      [user.firstName, user.Email, user.lastName]);
  print('Inserted row id=${result.insertId}');

  // Finally, close the connection
  await _conn.close();

}
 */