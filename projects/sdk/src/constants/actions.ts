export enum ActionType {
  /// GENERIC
  BASE,
  END_TOKEN,
  SWAP,
  RECEIVE_TOKEN,
  TRANSFER_BALANCE,

  /// SILO
  DEPOSIT,
  WITHDRAW,
  IN_TRANSIT,
  UPDATE_SILO_REWARDS,
  CLAIM_WITHDRAWAL,
  TRANSFER,

  /// FIELD
  BUY_BEANS,
  SOW_BEANS,
  RECEIVE_PODS,
  HARVEST,
  RECEIVE_BEANS,
  TRANSFER_PODS,

  /// MARKET
  CREATE_ORDER,
  BUY_PODS,
  SELL_PODS,

  /// BARN
  RINSE,
  BUY_FERTILIZER,
  RECEIVE_FERT_REWARDS
}
