import 'package:hasura_helper/src/hasura_entity.dart';
import 'package:hasura_helper/src/typedef.dart';

abstract class HasuraAction {
  HasuraAction({
    required this.method,
    required this.args,
    required this.returning,
  });

  final String method;
  final JsonMap args;
  final Set returning;

  static String _parseArgs(dynamic value, {bool outerBrackets = false}) {
    if (value == null) {
      return 'null';
    } else if (value is String) {
      return value.startsWith('\$')
          ? value.replaceAll('\\', '')
          : '"${value.replaceAll('"', '\\"')}"';
    } else if (value is Map) {
      final withoutBrackets = value.keys.map((k) {
        return '$k: ${_parseArgs(value[k], outerBrackets: true)}';
      }).join(', ');
      return outerBrackets ? '{$withoutBrackets}' : withoutBrackets;
    } else {
      return '$value';
    }
  }

  static String _parseReturning(dynamic value, {int depth = 1}) {
    final space = '  ' * depth;
    final closingSpace = '  ' * (depth - 1);

    if (value is Iterable) {
      return '{\n$space${value.map((v) {
        return _parseReturning(v, depth: depth + 1);
      }).join('\n$space')}\n$closingSpace}';
    } else if (value is HasuraEntity) {
      return value.parse(depth: depth);
    } else {
      return '$value';
    }
  }

  @override
  String toString() {
    return '$method(${_parseArgs(args)}) ${_parseReturning(returning)}';
  }
}
