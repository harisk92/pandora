import 'package:pandora/src/pandora_injector.dart';

enum ComponentType {
  Singleton,
  Factory,
}

abstract class ComponentProvider<T> {
  final ComponentType _componentType;
  T instance;

  ComponentProvider({ComponentType componentType})
      : _componentType = componentType;

  ComponentType get componentType => _componentType;

  Type get type => T;

  String get name => null;

  T provide(PandoraInjector injector) {
    switch (componentType) {
      case ComponentType.Singleton:
        if (instance == null) {
          instance = inject(injector);
        }
        break;
      default:
        if (instance != null) {
          dispose();
        }
        instance = inject(injector);
    }

    return instance;
  }

  T inject(PandoraInjector injector);

  void dispose();
}

abstract class SingletonComponentProvider<T> extends ComponentProvider<T> {
  SingletonComponentProvider() : super(componentType: ComponentType.Singleton);
}

abstract class FactoryComponentProvider<T> extends ComponentProvider<T> {
  FactoryComponentProvider() : super(componentType: ComponentType.Factory);
}
