// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {Password3V1} from "src/Password3V1.sol";

import {Script, console2} from "forge-std/Script.sol";

contract Password3Script is Script {
    function setUp() public {}

    function run() public {
        deployTransparent();
        // upgradeTransparent();
    }

    function getDeployeInfo()
        internal
        view
        returns (uint256, address, address)
    {
        string memory mnemonic = vm.envString("TEST_MNEMONIC");
        uint256 deployerKey = vm.deriveKey(mnemonic, 0);
        address deployerAddress = vm.addr(deployerKey);
        address owner = deployerAddress;
        console2.log("deployerAddress:", deployerAddress);
        console2.log("owner:", owner);
        return (deployerKey, deployerAddress, owner);
    }

    function deployUUPS() internal {
        (uint256 deployerKey, , address owner) = getDeployeInfo();

        vm.startBroadcast(deployerKey);

        address proxy = Upgrades.deployUUPSProxy(
            "Password3V1.sol",
            abi.encodeCall(Password3V1.initialize, (owner))
        );
        vm.stopBroadcast();
        Password3V1 instance = Password3V1(payable(proxy));

        address _owner = instance.owner();
        console2.log("proxy address:", proxy);
        console2.log("owner", _owner);
    }

    function deployTransparent() internal {
        (
            uint256 deployerKey,
            address deployerAddress,
            address owner
        ) = getDeployeInfo();

        vm.startBroadcast(deployerKey);
        address proxy = Upgrades.deployTransparentProxy(
            "Password3V1.sol",
            deployerAddress,
            abi.encodeCall(Password3V1.initialize, (owner))
        );

        vm.stopBroadcast();
        Password3V1 instance = Password3V1(payable(proxy));

        address _owner = instance.owner();
        console2.log("proxy address:", proxy);
        console2.log("owner", _owner);
    }

    function upgradeTransparent() internal {
        (uint256 deployerKey, , ) = getDeployeInfo();

        vm.startBroadcast(deployerKey);
        address proxy = vm.envAddress("PROXY_ADDRESS");
        Upgrades.upgradeProxy(proxy, "Password3V1.sol", "");
        vm.stopBroadcast();
    }
}
