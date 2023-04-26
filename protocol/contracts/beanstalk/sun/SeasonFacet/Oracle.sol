// SPDX-License-Identifier: MIT

pragma solidity =0.7.6;
pragma experimental ABIEncoderV2;

import "~/libraries/Minting/LibCurveMinting.sol";
import "~/beanstalk/ReentrancyGuard.sol";
import "~/libraries/Minting/LibWellMinting.sol";
import "@openzeppelin/contracts/math/SignedSafeMath.sol";

/**
 * @title Oracle
 * @author Publius, Chaikitty
 * @notice Tracks the Delta B in available pools.
 */
contract Oracle is ReentrancyGuard {
    
    using SignedSafeMath for int256;

    //////////////////// ORACLE GETTERS ////////////////////

    // TODO: Set
    address private constant BEAN_ETH_WELL =
        0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;

    /**
     * @notice Returns the current Delta B in the Curve liquidity pool.
     */
    function totalDeltaB() external view returns (int256 deltaB) {
        // TODO: Use SafeMath
        deltaB = LibCurveMinting.check().add(
            LibWellMinting.check(BEAN_ETH_WELL)
        );
    }

    /**
     * @notice Returns the current Delta B for the requested pool.
     */
    function poolDeltaB(address pool) external view returns (int256) {
        if (pool == C.CURVE_BEAN_METAPOOL) return LibCurveMinting.check();
        if (LibWell.isWell(pool)) return LibWellMinting.check(pool);
        revert("Oracle: Pool not supported");
    }

    //////////////////// ORACLE INTERNAL ////////////////////

    function stepOracle() internal returns (int256 deltaB, uint256[2] memory balances) {
        (deltaB, balances) = LibCurveMinting.capture();
        // TODO: Use SafeMath
        deltaB = deltaB.add(LibWellMinting.capture(BEAN_ETH_WELL));
        s.season.timestamp = block.timestamp;
    }

    function wellOracleSnapshot(address well) external view returns (bytes memory snapshot) {
        snapshot = s.wellOracleSnapshots[well];
    }
}
