// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {LibString} from "solmate/utils/LibString.sol";
import {Owned} from "solmate/auth/Owned.sol";

contract Rumas is Owned, ERC721("BRR Rumas", "RUMAS") {
    using LibString for uint256;

    string public baseTokenURI = "https://egap.j.page/rumas/metadata/";

    event SetBaseTokenURI(string);

    error InvalidNFT();

    constructor(address _owner) Owned(_owner) {}

    function tokenURI(uint256 id) public view override returns (string memory) {
        if (_ownerOf[id] == address(0)) revert InvalidNFT();

        return string.concat(baseTokenURI, id.toString());
    }

    function setBaseTokenURI(string calldata _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;

        emit SetBaseTokenURI(_baseTokenURI);
    }
}
