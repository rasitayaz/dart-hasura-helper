import 'package:hasura_helper/hasura_helper.dart';

void main() {
  final request = Hasura.insert(
    table: 'users',
    object: {
      'username': 'rasitayaz',
      'profession': 'developer',
    },
    returning: {'id'},
  );

  print(request.body);
}
