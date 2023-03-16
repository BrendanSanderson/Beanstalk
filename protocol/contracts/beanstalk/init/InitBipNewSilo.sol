/*
 SPDX-License-Identifier: MIT
*/

pragma solidity =0.7.6;
pragma experimental ABIEncoderV2;

import {IBean} from "../../interfaces/IBean.sol";
import {AppStorage} from "../AppStorage.sol";
import "~/C.sol";

/**
 * @author Publius
 * @title InitBip8 runs the code for BIP-8.
**/

contract InitBipNewSilo {

    AppStorage internal s;

    event UpdatedStalkPerBdvPerSeason(
        address indexed token,
        uint32 stalkEarnedPerSeason,
        uint32 season
    );
    
    
    function init() external {
        
        //update all silo info for current Silo-able assets

        uint32 currentSeason = s.season.current;

        s.ss[C.beanAddress()].stalkEarnedPerSeason = 2*1e6;
        s.ss[C.beanAddress()].stalkIssuedPerBdv = 10000;
        s.ss[C.beanAddress()].lastUpdateSeason = currentSeason;
        s.ss[C.beanAddress()].lastCumulativeGrownStalkPerBdv = 0;


        s.ss[C.curveMetapoolAddress()].stalkEarnedPerSeason = 4*1e6;
        s.ss[C.curveMetapoolAddress()].stalkIssuedPerBdv = 10000;
        s.ss[C.curveMetapoolAddress()].lastUpdateSeason = currentSeason;
        s.ss[C.curveMetapoolAddress()].lastCumulativeGrownStalkPerBdv = 0;


        s.ss[C.unripeBeanAddress()].stalkEarnedPerSeason = 2*1e6;
        s.ss[C.unripeBeanAddress()].stalkIssuedPerBdv = 10000;
        s.ss[C.unripeBeanAddress()].lastUpdateSeason = currentSeason;
        s.ss[C.unripeBeanAddress()].lastCumulativeGrownStalkPerBdv = 0;


        s.ss[address(C.unripeLP())].stalkEarnedPerSeason = 2*1e6;
        s.ss[address(C.unripeLP())].stalkIssuedPerBdv = 10000;
        s.ss[address(C.unripeLP())].lastUpdateSeason = currentSeason;
        s.ss[address(C.unripeLP())].lastCumulativeGrownStalkPerBdv = 0;

        //emit event for unripe LP from 4 to 2 grown stalk per bdv per season
        emit UpdatedStalkPerBdvPerSeason(address(C.unripeLP()), 2, s.season.current);



        //set the grownStalkPerBdvStartSeason to the current season
        s.season.grownStalkPerBdvStartSeason = uint16(s.season.current); //storing as uint16 to save storage space
    }
}