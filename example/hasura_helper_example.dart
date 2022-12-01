import 'package:hasura_helper/hasura_helper.dart';

void main() {
  Hasura? request;

  /// basic usage

  request = Hasura.insert(
    table: 'users',
    object: {
      'username': 'rasitayaz',
      'profession': 'developer',
    },
    returning: {'id'},
  );

  print(request.body);

  /// multiple queries (or mutations)

  request = Hasura.query(
    actions: [
      HasuraQuery.list(
        table: 'users',
        where: {
          'profession': {'_eq': 'developer'},
        },
        returning: {'id', 'username'},
      ),
      HasuraQuery.byId(
        table: 'users',
        id: 1,
        returning: {'id', 'profession'},
      ),
    ],
  );

  print(request.body);

  /// with jsonb variables

  request = Hasura.updateById(
    table: 'users',
    id: 1,
    variables: {
      'education': {
        'school': 'marmara university',
        'department': 'computer engineering',
      },
    },
    args: {
      '_set': {'education': '\$education'},
    },
    returning: {'id'},
  );

  print(request.body);

  /// using entities for relations

  request = Hasura.queryById(
    table: 'users',
    id: 1,
    returning: {
      'id',
      HasuraEntity(
        'messages',
        args: {
          'limit': 20,
          'order_by': {'date': 'desc'},
        },
        fields: {'id', 'text'},
      ),
    },
  );

  print(request.body);
}
