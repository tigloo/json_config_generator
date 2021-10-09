import 'package:build/build.dart' show Builder, BuilderOptions;
import 'package:json_config_generator/src/generator.dart';
import 'package:source_gen/source_gen.dart';

Builder configBuilder(BuilderOptions options) {
  return SharedPartBuilder(
      const [JsonConfigGenerator()], 'json_config_generator');
}
