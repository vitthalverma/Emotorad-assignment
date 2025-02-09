part of 'reward_bloc.dart';

sealed class RewardEvent {}

class AppStartedEvent extends RewardEvent {}

class ScratchCardTappedEvent extends RewardEvent {}

class RedeemItemEvent extends RewardEvent {
  final RewardItem item;
  RedeemItemEvent({required this.item});
}

class RefreshEvent extends RewardEvent {}

class FilterTransactionsEvent extends RewardEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionType? type;

  FilterTransactionsEvent({this.startDate, this.endDate, this.type});
}
