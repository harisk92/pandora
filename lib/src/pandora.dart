import 'package:pandora/src/module.dart';
import 'package:pandora/src/pandora_injector.dart';

class Pandora {
  static final Pandora _singleton = Pandora._internal();
  PandoraInjector injector;

  factory Pandora() {
    return _singleton;
  }

  Pandora._internal() {
    injector = PandoraInjector();
  }

  static injectModule(Module module) {
    return _singleton.injector.inject(module);
  }

  static injectModules(List<Module> modules) {
    return modules.forEach((module) => _singleton.injector.inject(module));
  }

  static removeModule(Type type) {
    _singleton.injector.remove(type);
  }

  static T provide<T>({String named}) {
    return _singleton.injector.provide<T>(named: named);
  }
}
