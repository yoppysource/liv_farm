enum ProductCategory {
  vegetable,
  leafyVegetable,
  salad,
  sandwich,
  vegetableJuice,
  coffee,
  drinks,
  dressing,
  set,
}

extension Extension on ProductCategory {
  String get string {
    switch (this) {
      case ProductCategory.vegetable:
        return '송이채소';
      case ProductCategory.leafyVegetable:
        return '잎채소';
      case ProductCategory.salad:
        return '샐러드';
      case ProductCategory.sandwich:
        return '샌드위치';
      case ProductCategory.vegetableJuice:
        return '채소주스';
      case ProductCategory.coffee:
        return '커피';
      case ProductCategory.drinks:
        return '음료';
      case ProductCategory.dressing:
        return '드레싱';
      case ProductCategory.set:
        return '세트';
      default:
        return 'unDefined';
    }
  }
}
