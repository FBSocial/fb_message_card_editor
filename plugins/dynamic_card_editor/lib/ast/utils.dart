T? handleNum<T extends num>(Object? value) {
  if (value is String) {
    return num.parse(value) as T?;
  } else if (value is num) {
    return value as T?;
  }
  return null;
}
