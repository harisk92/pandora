import 'dart:collection';

import 'package:pandora/src/component_provider.dart';
import 'package:pandora/src/pandora_injector.dart';

class _Key {
  Type type;
  String name;

  _Key({this.type, this.name: ""});

  @override
  String toString() {
    return '$type$name';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Key &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          name == other.name;

  @override
  int get hashCode => type.hashCode ^ name.hashCode;
}

class Module {
  Map<_Key, ComponentProvider> _componentProviders = HashMap();

  Module(List<ComponentProvider> components) {
    components.forEach(inject);
  }

  void inject(ComponentProvider component) {
    _Key key = _Key(name: component.name, type: component.type);
    _componentProviders.putIfAbsent(key, () => component);
  }

  void removeProvider<T>({String named}) {
    _Key key = _Key(name: named, type: T);
    ComponentProvider component = _componentProviders.remove(key);
    if (component != null) {
      component.dispose();
    }
  }

  void dispose() {
    _componentProviders.forEach((_, component) => component.dispose());
    _componentProviders.clear();
  }

  bool hasComponentProvider<T>({String named}) {
    _Key key = _Key(name: named, type: T);
    return _componentProviders.containsKey(key);
  }

  T get<T>(PandoraInjector injector, {String named}) {
    _Key key = _Key(name: named, type: T);
    return _componentProviders[key].provide(injector);
  }
}
