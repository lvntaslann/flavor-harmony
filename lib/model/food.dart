class FoodItem {
  final String name;
  final double calories;
  final String? imageUrl;
  final double? amount;

  FoodItem({
    required this.name,
    required this.calories,
    this.imageUrl,
    this.amount,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['label'],
      calories: json['nutrients']['ENERC_KCAL'] != null
          ? (json['nutrients']['ENERC_KCAL'] as num).toDouble()
          : 0.0,
      imageUrl: json['image'],
      amount: json['amount'] != null ? json['amount'].toDouble() : null,
    );
  }

  FoodItem copyWithAmount(double newAmount) {
    return FoodItem(
      name: this.name,
      calories: this.calories * newAmount / 100,
      imageUrl: this.imageUrl,
      amount: newAmount,
    );
  }
}