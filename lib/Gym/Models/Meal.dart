class Meal {
  String _name = '';
  int kcal = 0;
  Nutrients nutrients = new Nutrients();
  List<String> incredients = List<String>();
  List<String> recipie = List<String>();
  String prep = '';

  Meal(this._name,
      {this.kcal, this.nutrients, this.incredients, this.recipie, this.prep});
}

class Nutrients {
  double carbs = 0.0;
  double protein = 0.0;
  double fats = 0.0;
  double water = 0.0;
  List<String> vitamins = new List<String>();
  int energy = 0;
  int calcium = 0;
  int sodium = 0;
  int potassium = 0;
  double fibre = 0.0;
  double salt = 0.0;

  Nutrients(
      {this.carbs,
      this.protein,
      this.fats,
      this.water,
      this.vitamins,
      this.energy,
      this.calcium,
      this.sodium,
      this.potassium,
      this.fibre,
      this.salt});

  @override
  String toString() {
    return 'Nutrients{carbs: $carbs, protein: $protein, fats: $fats, water: $water, vitamins: $vitamins, energy: $energy, calcium: $calcium, sodium: $sodium, potassium: $potassium, fibre: $fibre, salt: $salt}';
  }
}
