// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ZilongToken} from "src/erc20/ZilongToken.sol";
import {Script} from "forge-std/Script.sol";

contract DeployToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1_000e18;

    function run() public returns (ZilongToken) {
        vm.startBroadcast();
        ZilongToken zilongToken = new ZilongToken(INITIAL_SUPPLY);
        vm.stopBroadcast();

        return zilongToken;
    }
}
