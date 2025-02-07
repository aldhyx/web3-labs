// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {DeployToken} from "script/DeployToken.s.sol";
import {ZilongToken} from "src/erc20/ZilongToken.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract ZilongTokenTest is Test {
    ZilongToken public token;
    DeployToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    uint256 public constant STARTING_BALANCE = 100e18;

    function setUp() public {
        deployer = new DeployToken();
        token = deployer.run();

        vm.prank(msg.sender);
        token.transfer(bob, STARTING_BALANCE);
    }

    function testInitialSupply() public view {
        assertEq(token.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testBobBalance() public view {
        assertEq(token.balanceOf(bob), STARTING_BALANCE);
    }

    function testTransfer() public {
        uint256 transferAmount = 5;
        vm.prank(bob);
        token.transfer(alice, transferAmount);

        assertEq(token.balanceOf(alice), transferAmount);
        assertEq(token.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 10;

        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        token.approve(alice, initialAllowance);

        uint256 transferAmount = 5;
        vm.prank(alice);
        token.transferFrom(bob, alice, transferAmount);
        assertEq(token.balanceOf(alice), transferAmount);
        assertEq(token.balanceOf(bob), STARTING_BALANCE - transferAmount);

        // Check allowance after transfer
        uint256 newAllowance = 0;
        vm.prank(bob);
        token.approve(alice, newAllowance);
        assertEq(token.allowance(bob, alice), newAllowance);
    }
}
