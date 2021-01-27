/// A convenience class for making simple enum mappers.
///
/// Create your enum and mapper:
/// ```
/// enum SomeEnum {
///   One, Two, Three
/// }
///
/// class SomeEnumMapper {
///   static const EnumMapper<SomeEnum, String> instance = const EnumMapper({
///     SomeEnum.One: 1,
///     SomeEnum.Two: 2,
///     SomeEnum.Three: 3,
///   });
/// }
/// ```
///
/// Then use the mapper like so:
/// ```
/// SomeEnumMapper.instance.getEnum(1); // Returns SomeEnum.One
/// SomeEnumMapper.instance.getValue(SomeEnum.One); // Returns 1
/// ```
class EnumMapper<T, V> {
  const EnumMapper(this.values);

  /// A map of enums and their values.
  final Map<T, V> values;

  /// Gets the enum by value.
  T? getEnum(V value) =>
      values.keys.firstWhere((t) => values[t] == value, orElse: null);

  /// Get the enum value.
  /// This may return null if the enum hasn't been added to the values map.
  V? getValue(T enumMember) => values[enumMember];
}
