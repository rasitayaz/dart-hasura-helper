import 'package:hasura_helper/src/typedef.dart';

class HasuraEntity {
  HasuraEntity(
    this.name, {
    this.args,
    this.fields,
  });

  final String name;
  final JsonMap? args;
  final Set? fields;

  String parse({required int depth}) {
    final args = this.args;
    final fields = this.fields;

    final space = '  ' * depth;
    final closingSpace = '  ' * (depth - 1);

    return [
      name,
      if (args != null)
        '(${args.entries.map((e) => '${e.key}: ${e.value}').join(', ')})',
      if (fields != null)
        '{\n$space${fields.map((field) {
          if (field is HasuraEntity) {
            return field.parse(depth: depth + 1);
          } else {
            return '$field';
          }
        }).join('\n$space')}\n$closingSpace}',
    ].join(' ');
  }

  @override
  String toString() {
    return [
      name,
      if (args != null) '($args)',
      if (fields != null) ' {\n${fields!.join('\n')}\n}',
    ].join();
  }
}
