// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Password3V1} from "../src/Password3V1.sol";
import {Utils} from "./utils/Utils.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {Script, console} from "forge-std/Script.sol";
error OwnableUnauthorizedAccount(address account);

contract Password3Test is Test, Password3V1 {
    Password3V1 public password3;
    Utils public utils;
    address cowner;
    uint256 expireAfter = 1 days;

    function setUp() public {
        password3 = new Password3V1();
        cowner = password3.owner();
        utils = new Utils();
    }

    function test_GetEmailHash() public {}
}
