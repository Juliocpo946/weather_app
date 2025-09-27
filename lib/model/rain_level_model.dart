enum RainLevel {
  ligera(
    name: 'Ligera',
    count: 100,
    farSpeed: 10,
    nearSpeed: 4,
    farLength: 10,
    nearLength: 20,
    farWidth: 1,
    nearWidth: 2,
  ),
  moderada(
    name: 'Moderada',
    count: 250,
    farSpeed: 15,
    nearSpeed: 6,
    farLength: 12,
    nearLength: 25,
    farWidth: 1,
    nearWidth: 2.5,
  ),
  fuerte(
    name: 'Fuerte',
    count: 400,
    farSpeed: 20,
    nearSpeed: 8,
    farLength: 15,
    nearLength: 30,
    farWidth: 1.5,
    nearWidth: 3,
  ),
  torrencial(
    name: 'Torrencial',
    count: 600,
    farSpeed: 30,
    nearSpeed: 12,
    farLength: 20,
    nearLength: 40,
    farWidth: 2,
    nearWidth: 4,
  );

  final String name;
  final int count;
  final double farSpeed;
  final double nearSpeed;
  final double farLength;
  final double nearLength;
  final double farWidth;
  final double nearWidth;

  const RainLevel({
    required this.name,
    required this.count,
    required this.farSpeed,
    required this.nearSpeed,
    required this.farLength,
    required this.nearLength,
    required this.farWidth,
    required this.nearWidth,
  });
}

