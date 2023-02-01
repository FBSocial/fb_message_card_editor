T? handleNum<T extends num>(Object? value) {
  if (value is String) {
    if(value.isEmpty) return null;
    return num.parse(value) as T?;
  } else if (value is num) {
    return value as T?;
  }
  return null;
}
