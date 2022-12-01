import 'package:hasura_helper/src/hasura_action.dart';
import 'package:hasura_helper/src/hasura_entity.dart';
import 'package:hasura_helper/src/typedef.dart';

class HasuraMutation extends HasuraAction {
  /// creates a custom mutation
  HasuraMutation({
    required super.method,
    required super.args,
    required super.returning,
  });

  /// insert_[table]_one
  HasuraMutation.insert({
    required String table,
    required JsonMap object,
    required Set returning,
  }) : super(
          method: 'insert_${table}_one',
          args: {'object': object},
          returning: returning,
        );

  /// update_[table]_by_pk
  HasuraMutation.updateById({
    required String table,
    required int id,
    required JsonMap args,
    required Set returning,
  }) : super(
          method: 'update_${table}_by_pk',
          args: {
            'pk_columns': {'id': id},
            ...args,
          },
          returning: returning,
        );

  /// update_[table]
  HasuraMutation.update({
    required String table,
    required JsonMap args,
    required Set returning,
  }) : super(
          method: 'update_$table',
          args: args,
          returning: {HasuraEntity('returning', fields: returning)},
        );

  /// delete_[table]_by_pk
  HasuraMutation.deleteById({
    required String table,
    required int id,
    required Set returning,
  }) : super(
          method: 'delete_${table}_by_pk',
          args: {'id': id},
          returning: returning,
        );
}
