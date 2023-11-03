// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {LibString} from "solmate/utils/LibString.sol";
import {Rumas} from "src/Rumas.sol";

contract RumasTest is Test {
    using LibString for uint256;

    Rumas public immutable rumas;

    constructor() {
        rumas = new Rumas(address(this));
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
    }

    function testSetBaseTokenURIFuzz(string calldata baseTokenURI) external {
        address msgSender = rumas.owner();

        vm.prank(msgSender);
        vm.expectEmit(false, false, false, true, address(rumas));

        emit Rumas.SetBaseTokenURI(baseTokenURI);

        rumas.setBaseTokenURI(baseTokenURI);

        assertEq(baseTokenURI, rumas.baseTokenURI());
    }
}
