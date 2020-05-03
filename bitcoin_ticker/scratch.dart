class Fruit {
  Fruit(this.name);

  String name;

  @override
  String toString() {
    return name;
  }
}

void main() {
  var fruits = [
    Fruit(
      'Apple',
    ),
    Fruit(
      'Pinaple',
    ),
    Fruit(
      'Melon',
    ),
    Fruit(
      'Apple',
    ),
  ];
  print(fruits.length);
  for (Fruit fruit in fruits) {
    print(fruit);
  }
}
