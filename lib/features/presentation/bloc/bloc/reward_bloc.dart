import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/reward_repository_impl.dart';
import '../../../domain/entites/reward_item.dart';
import '../../../domain/entites/reward_transaction.dart';

part 'reward_event.dart';
part 'reward_state.dart';

//  USUALLY INTERACTS WITH USECASES BUT FOR SIMPLICITY IT IS INTERACTING WITH REPO

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final RewardRepositoryImpl repository;

  RewardBloc({required this.repository})
      : super(RewardState(
          coinBalance: repository.getCoinBalance(),
          transactions: repository.getTransactionHistory(),
          filteredTransactions: repository.getTransactionHistory(),
          redeemableItems: _buildRedeemableItems(),
        )) {
    on<AppStartedEvent>(_onAppStarted);
    on<ScratchCardTappedEvent>(_onScratchCardTapped);
    on<RedeemItemEvent>(_onRedeemItem);
    on<RefreshEvent>(_onRefresh);
    on<FilterTransactionsEvent>(_onFilterTransactions);
  }

  /// Initializes the state.
  void _onAppStarted(AppStartedEvent event, Emitter<RewardState> emit) {
    emit(state.copyWith(
      coinBalance: repository.getCoinBalance(),
      lastScratchTime: repository.getLastScratchTime(),
      transactions: repository.getTransactionHistory(),
    ));
  }

  /// Handles scratch card events.
  void _onScratchCardTapped(
      ScratchCardTappedEvent event, Emitter<RewardState> emit) async {
    try {
      final reward = await repository.scratchCardReward();
      emit(state.copyWith(
        coinBalance: repository.getCoinBalance(),
        lastScratchTime: repository.getLastScratchTime(),
        transactions: repository.getTransactionHistory(),
        scratchRewardMessage: 'You earned $reward coins!',
        redemptionMessage: null,
      ));
    } catch (e) {
      // In case the scratch card is not yet available.
      final nextAvailable =
          state.lastScratchTime?.add(const Duration(hours: 1));
      emit(state.copyWith(
          scratchRewardMessage:
              'Scratch card not available. Try again at ${nextAvailable?.toLocal().toString().split(".")[0]}'));
    }
  }

  /// Handles redemption events.
  void _onRedeemItem(RedeemItemEvent event, Emitter<RewardState> emit) async {
    final success = await repository.redeemItem(event.item);
    if (success) {
      emit(state.copyWith(
        coinBalance: repository.getCoinBalance(),
        transactions: repository.getTransactionHistory(),
        redemptionMessage: 'Successfully redeemed ${event.item.name}!',
        scratchRewardMessage: null,
      ));
    } else {
      emit(state.copyWith(
        redemptionMessage: 'Insufficient Coins',
        scratchRewardMessage: null,
      ));
    }
  }

  /// Refreshes the state.
  void _onRefresh(RefreshEvent event, Emitter<RewardState> emit) {
    emit(state.copyWith(
      coinBalance: repository.getCoinBalance(),
      lastScratchTime: repository.getLastScratchTime(),
      transactions: repository.getTransactionHistory(),
    ));
  }

  void _onFilterTransactions(
    FilterTransactionsEvent event,
    Emitter<RewardState> emit,
  ) {
    // Retrieve the full list from the repository.
    final allTransactions = repository.getTransactionHistory();

    // If no filter is applied, use all transactions.
    if (event.startDate == null &&
        event.endDate == null &&
        event.type == null) {
      emit(state.copyWith(filteredTransactions: allTransactions));
      return;
    }

    // Otherwise, apply the filters.
    List<RewardTransaction> filtered = allTransactions;
    if (event.startDate != null) {
      filtered =
          filtered.where((tx) => tx.date.isAfter(event.startDate!)).toList();
    }
    if (event.endDate != null) {
      filtered =
          filtered.where((tx) => tx.date.isBefore(event.endDate!)).toList();
    }
    if (event.type != null) {
      filtered = filtered.where((tx) => tx.type == event.type).toList();
    }
    emit(state.copyWith(filteredTransactions: filtered));
  }

  /// Creates a hard-coded list of redeemable items.
  static List<RewardItem> _buildRedeemableItems() {
    return [
      RewardItem(id: '1', name: 'Discount Coupon', cost: 300),
      RewardItem(id: '2', name: 'Gift Card', cost: 700),
      RewardItem(id: '3', name: 'Exclusive Access', cost: 1200),
    ];
  }
}
