import 'package:hasura_helper/src/hasura_action.dart';
import 'package:hasura_helper/src/typedef.dart';

class HasuraQuery extends HasuraAction {
  /// creates a custom query
  HasuraQuery({
    required super.method,
    required super.args,
    required super.returning,
  });

  /// [table]_by_pk
  HasuraQuery.byId({
    required String table,
    required int id,
    required Set returning,
  }) : this(
          method: '${table}_by_pk',
          args: {'id': id},
          returning: returning,
        );

  /// [table]
  HasuraQuery.list({
    required String table,
    JsonMap? where,
    required Set returning,
  }) : this(
          method: table,
          args: {'where': where ?? {}},
          returning: returning,
        );
}
