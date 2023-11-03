// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {LibString} from "solmate/utils/LibString.sol";

contract BaseRumas is ERC721("BRR Rumas", "RUMAS") {
    using LibString for uint256;

    string private _baseTokenURI = "https://egap.j.page/rumas/metadata/";

    function tokenURI(uint256 id) public view override returns (string memory) {
        return string.concat(_baseTokenURI, id.toString());
    }
}
