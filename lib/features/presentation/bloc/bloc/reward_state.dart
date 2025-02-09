part of 'reward_bloc.dart';

class RewardState {
  final int coinBalance;
  final DateTime? lastScratchTime;
  final String? scratchRewardMessage;
  final String? redemptionMessage;
  final List<RewardTransaction> transactions;
  final List<RewardTransaction> filteredTransactions;
  final List<RewardItem> redeemableItems;

  RewardState({
    required this.coinBalance,
    this.lastScratchTime,
    this.scratchRewardMessage,
    this.redemptionMessage,
    required this.transactions,
    required this.filteredTransactions,
    required this.redeemableItems,
  });

  RewardState copyWith({
    int? coinBalance,
    DateTime? lastScratchTime,
    String? scratchRewardMessage,
    String? redemptionMessage,
    List<RewardTransaction>? transactions,
    List<RewardTransaction>? filteredTransactions,
    List<RewardItem>? redeemableItems,
  }) {
    return RewardState(
      coinBalance: coinBalance ?? this.coinBalance,
      lastScratchTime: lastScratchTime ?? this.lastScratchTime,
      scratchRewardMessage: scratchRewardMessage,
      redemptionMessage: redemptionMessage,
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      redeemableItems: redeemableItems ?? this.redeemableItems,
    );
  }
}
