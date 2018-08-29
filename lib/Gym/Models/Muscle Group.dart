class MuscleGroup {
  final Chest chest;
  final Back back;
  final Legs legs;
  final Arms arms;
  final Core core;
  final Glute glute;

  MuscleGroup(
      this.chest, this.back, this.legs, this.arms, this.core, this.glute);
}

abstract class Glute {
  final String glute = 'Glute';
  final String hips = 'Hips';
}

abstract class Core {
  final String abdominal = 'abdominal';
  final String obliques = 'Obliques';
  final String lower_back = 'Lower Back';
}

abstract class Arms {
  final String biceps = 'Biceps';
  final String triceps = 'Triceps';
  final String forearms = 'Forearms';
}

abstract class Legs {
  final String quads = 'Quads';
  final String calves = 'Calves';
  final String ham_string = 'Ham String';
  final String adductors = 'Adductors';
  final String abductors = 'Abductors';
}

abstract class Back {
  final String lats = 'Lats';
  final String traps = 'Traps';
  final String obliques = 'Obliques';
  final String lower_back = 'Lower Back';
}

abstract class Chest {
  final String upperPec = 'Upper Peck';
  final String LowerPec = 'Lower Peck';
}
