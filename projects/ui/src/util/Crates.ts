import BigNumber from 'bignumber.js';
import Token from '~/classes/Token';
import { TokenMap } from '~/constants';
import { Beanstalk } from '~/generated';
import { LegacyDepositCrate, FarmerSiloBalance } from '~/state/farmer/silo';

/**
 * @deprecated TOOD: Remove this
 */
export const STALK_PER_SEED_PER_SEASON = 1 / 10_000;

/**
 * @deprecated TODO: Refactor this to a selector, use the SDK
 */
export const selectCratesForEnroot = (
  beanstalk: Beanstalk,
  unripeTokens: TokenMap<Token>,
  siloBalances: TokenMap<FarmerSiloBalance>,
  getBDV: (_token: Token) => BigNumber
) =>
  Object.keys(unripeTokens).reduce<{
    [addr: string]: { crates: LegacyDepositCrate[]; encoded: string };
  }>((prev, addr) => {
    const crates = siloBalances[addr]?.deposited.crates.filter((crate) =>
      /// only select crates where BDV would stay the same or increase
      /// solves bug where fluctuations in unripe bdv cause enroots
      /// to fail in certain conditions.
      new BigNumber(
        getBDV(unripeTokens[addr]).times(crate.amount).toFixed(6, 1)
      ).gt(crate.bdv)
    );

    if (crates && crates.length > 0) {
      if (crates.length === 1) {
        prev[addr] = {
          crates,
          encoded: beanstalk.interface.encodeFunctionData('enrootDeposit', [
            addr,
            crates[0].stem.toString(),
            unripeTokens[addr].stringify(crates[0].amount), // amount
          ]),
        };
      } else {
        prev[addr] = {
          crates,
          encoded: beanstalk.interface.encodeFunctionData('enrootDeposits', [
            addr,
            crates.map((crate) => crate.stem.toString()),
            crates.map((crate) => unripeTokens[addr].stringify(crate.amount)), // amounts
          ]),
        };
      }
    }
    return prev;
  }, {});
