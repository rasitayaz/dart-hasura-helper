import 'package:hasura_helper/src/hasura_action.dart';
import 'package:hasura_helper/src/hasura_mutation.dart';
import 'package:hasura_helper/src/hasura_query.dart';
import 'package:hasura_helper/src/typedef.dart';

/// This is a helper class for Hasura (https://hasura.io/) GraphQL API.
/// It helps you to build queries and mutations with ease.
class Hasura {
  /// creates a request with multiple [HasuraQuery] actions
  Hasura.query({
    required List<HasuraQuery> this.actions,
  }) : variables = null;

  /// [table]_by_pk
  Hasura.queryById({
    required String table,
    required int id,
    required Set returning,
  })  : variables = null,
        actions = [
          HasuraQuery.byId(
            table: table,
            id: id,
            returning: returning,
          ),
        ];

  /// [table]
  Hasura.queryList({
    required String table,
    JsonMap? where,
    required Set returning,
  })  : variables = null,
        actions = [
          HasuraQuery.list(
            table: table,
            where: where,
            returning: returning,
          ),
        ];

  /// creates a request with multiple [HasuraMutation] actions
  Hasura.mutation({
    this.variables,
    required this.actions,
  });

  /// insert_[table]_one
  Hasura.insert({
    this.variables,
    required String table,
    required JsonMap object,
    required Set returning,
  }) : actions = [
          HasuraMutation.insert(
            table: table,
            object: object,
            returning: returning,
          ),
        ];

  /// update_[table]_by_pk
  Hasura.updateById({
    this.variables,
    required String table,
    required int id,
    required JsonMap args,
    required Set returning,
  }) : actions = [
          HasuraMutation.updateById(
            table: table,
            id: id,
            args: args,
            returning: returning,
          ),
        ];

  /// update_[table]
  Hasura.update({
    this.variables,
    required String table,
    required JsonMap args,
    required Set returning,
  }) : actions = [
          HasuraMutation.update(
            table: table,
            args: args,
            returning: returning,
          ),
        ];

  /// delete_[table]_by_pk
  Hasura.deleteById({
    this.variables,
    required String table,
    required int id,
    required Set returning,
  }) : actions = [
          HasuraMutation.deleteById(
            table: table,
            id: id,
            returning: returning,
          ),
        ];

  /// json variables to use in actions
  final JsonMap? variables;

  /// list of actions to execute
  final List<HasuraAction> actions;

  /// whether this is a mutation
  ///
  /// can be used to disable caching
  bool get isMutation => actions.first is HasuraMutation;

  /// build the request body
  JsonMap get body {
    final variables = this.variables;

    return {
      'variables': variables,
      'query': [
        actions.first is HasuraMutation ? 'mutation' : 'query',
        if (variables != null)
          '(${variables.keys.map((k) => '\$$k: jsonb').join(', ')})',
        '{\n${actions.join('\n')}\n}',
      ].join(' '),
    };
  }

  @override
  int get hashCode => body.hashCode;

  @override
  bool operator ==(Object other) {
    return super.hashCode == other.hashCode;
  }
}
