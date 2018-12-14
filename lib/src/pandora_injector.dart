import 'dart:collection';

import 'package:pandora/pandora.dart';

class PandoraInjector {
  final Map<Type, Module> _modules = HashMap();

  Pandora(List<Module> modules) {
    modules.forEach(inject);
  }

  void inject(Module module) {
    _modules.putIfAbsent(module.runtimeType, () => module);
  }

  void remove(Type type) {
    Module module = _modules[type];
    if (module != null) {
      module.dispose();
    }
  }

  T provide<T>({String named}) {
    for (Module module in _modules.values) {
      if (module.hasComponentProvider<T>(named: named)) {
        return module.get(this, named: named);
      }
    }
    return null;
  }
}
