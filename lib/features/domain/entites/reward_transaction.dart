enum TransactionType { scratchReward, redemption }

class RewardTransaction {
  final DateTime date;
  final TransactionType type;
  final int amount;
  final String description;

  RewardTransaction({
    required this.date,
    required this.type,
    required this.amount,
    required this.description,
  });
}
