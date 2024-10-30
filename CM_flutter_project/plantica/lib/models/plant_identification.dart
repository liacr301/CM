class PlantIdentification {
  final int id;
  final String? commonName;
  final String? scientificName;
  final String? description;
  final String? imageUrl;
  final String? watering;
  final String? bestWatering;
  final String? bestLightCondition;
  final String? bestSoilType;
  final String? toxicity;

  PlantIdentification({
    required this.id,
    this.commonName,
    this.scientificName,
    this.description,
    this.imageUrl,
    this.watering,
    this.bestWatering,
    this.bestLightCondition,
    this.bestSoilType,
    this.toxicity,
  });
}