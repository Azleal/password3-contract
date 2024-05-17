// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

//common utilities for forge tests
contract Utils is Test {
    // Vm internal immutable vm = Vm(VM_ADDRESS);
    bytes32 internal nextUser = keccak256(abi.encodePacked("user address"));

    function getUserPkAndAddress() external returns (uint256, address payable) {
        uint256 pk = uint256(nextUser);
        address payable addr = payable(vm.addr(pk));
        vm.deal(addr, 100 ether);
        nextUser = keccak256(abi.encodePacked(nextUser));
        return (pk, addr);
    }

    function getNextUserAddress() external returns (address payable) {
        //bytes32 to address conversion
        address payable user = payable(address(uint160(uint256(nextUser))));
        nextUser = keccak256(abi.encodePacked(nextUser));
        vm.deal(user, 100 ether);
        return user;
    }

    //create users with 100 ether balance
    function createUsers(
        uint256 userNum
    ) external returns (address payable[] memory) {
        address payable[] memory users = new address payable[](userNum);
        for (uint256 i = 0; i < userNum; i++) {
            address payable user = this.getNextUserAddress();
            users[i] = user;
        }
        return users;
    }

    //move block.number forward by a given number of blocks
    function mineBlocks(uint256 numBlocks) external {
        uint256 targetBlock = block.number + numBlocks;
        vm.roll(targetBlock);
    }
}
