// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {LibString} from "solmate/utils/LibString.sol";
import {Rumas} from "src/Rumas.sol";

contract RumasTest is Test {
    using LibString for uint256;

    Rumas public immutable rumas;
    address[] public initialTokenRecipients = [address(this)];
    uint256[] public initialTokenIds = [uint256(1)];

    constructor() {
        rumas = new Rumas(
            address(this),
            initialTokenRecipients,
            initialTokenIds
        );
    }

    /*//////////////////////////////////////////////////////////////
                             tokenURI
    //////////////////////////////////////////////////////////////*/

    function testCannotTokenURIInvalidNFT() external {
        uint256 id = type(uint256).max;

        vm.expectRevert(Rumas.InvalidNFT.selector);

        rumas.tokenURI(id);
    }

    function testTokenURI() external {
        uint256 id = initialTokenIds[0];
        string memory tokenURI = rumas.tokenURI(id);

        assertEq(string.concat(rumas.baseTokenURI(), id.toString()), tokenURI);
    }

    /*//////////////////////////////////////////////////////////////
                             setBaseTokenURI
    //////////////////////////////////////////////////////////////*/

    function testCannotSetBaseTokenURIUnauthorized() external {
        address msgSender = address(0);
        string memory baseTokenURI = "https://brrito.xyz/";

        assertTrue(msgSender != rumas.owner());

        vm.prank(msgSender);
        vm.expectRevert("UNAUTHORIZED");

        rumas.setBaseTokenURI(baseTokenURI);
    }

    function testSetBaseTokenURI() external {
        address msgSender = rumas.owner();
        string memory baseTokenURI = "https://brrito.xyz/";

        vm.prank(msgSender);
        vm.expectEmit(false, false, false, true, address(rumas));

        emit Rumas.SetBaseTokenURI(baseTokenURI);

        rumas.setBaseTokenURI(baseTokenURI);

        assertEq(baseTokenURI, rumas.baseTokenURI());

        uint256 id = initialTokenIds[0];

        assertEq(
            string.concat(baseTokenURI, id.toString()),
            rumas.tokenURI(id)
        );
    }

    function testSetBaseTokenURIFuzz(string calldata baseTokenURI) external {
        address msgSender = rumas.owner();

        vm.prank(msgSender);
        vm.expectEmit(false, false, false, true, address(rumas));

        emit Rumas.SetBaseTokenURI(baseTokenURI);

        rumas.setBaseTokenURI(baseTokenURI);

        assertEq(baseTokenURI, rumas.baseTokenURI());

        uint256 id = initialTokenIds[0];

        assertEq(
            string.concat(baseTokenURI, id.toString()),
            rumas.tokenURI(id)
        );
    }
}
