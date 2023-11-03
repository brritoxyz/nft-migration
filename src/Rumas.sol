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

    constructor(
        address _owner,
        address[] memory initialTokenRecipients,
        uint256[] memory initialTokenIds
    ) Owned(_owner) {
        uint256 iterations = initialTokenRecipients.length;

        // During contract creation, any number of NFTs may be created and assigned without emitting `Transfer`:
        // https://eips.ethereum.org/EIPS/eip-721#specification.
        for (uint256 i = 0; i < iterations; ++i) {
            unchecked {
                _balanceOf[initialTokenRecipients[i]]++;
            }

            _ownerOf[initialTokenIds[i]] = initialTokenRecipients[i];
        }
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        if (_ownerOf[id] == address(0)) revert InvalidNFT();

        return string.concat(baseTokenURI, id.toString());
    }

    function setBaseTokenURI(string calldata _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;

        emit SetBaseTokenURI(_baseTokenURI);
    }
}
