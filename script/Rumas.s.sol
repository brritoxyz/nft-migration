// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Rumas} from "src/Rumas.sol";

contract RumasScript is Script {
    function _getAirdropData()
        internal
        view
        returns (address[] memory recipients, uint256[] memory tokenIds)
    {
        // Rumas owners and token IDs at the time of the post-mint snapshot:
        // https://github.com/brritoxyz/token-distribution/blob/main/src/generateRumasAirdrop.js.
        string memory file = vm.readFile("script/airdropData/index.json");

        recipients = vm.parseJsonAddressArray(file, ".initialTokenRecipients");
        tokenIds = vm.parseJsonUintArray(file, ".initialTokenIds");
    }

    function run() public {
        (
            address[] memory recipients,
            uint256[] memory tokenIds
        ) = _getAirdropData();

        vm.broadcast(vm.envUint("PRIVATE_KEY"));

        new Rumas(vm.envAddress("OWNER"), recipients, tokenIds);
    }
}
