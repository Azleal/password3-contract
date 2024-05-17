// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Password3V1 is Initializable, OwnableUpgradeable {
    uint256 constant DEFAULT_MAX_VAULT_PER_ADDRESS = 3;

    uint256 public totalVaults;
    mapping(address => uint256[]) private vaults;
    mapping(uint256 => Vault) public vaultMapping;

    struct Vault {
        uint256 id;
        address owner;
        uint256 createdAt;
        string title;
        string entrypoint;
    }

    event VaultCreated(uint256 indexed vaultId, address indexed owner);

    modifier onlyVaultOwner(uint256 vaultId) {
        require(msg.sender == vaultMapping[vaultId].owner, "not your vault");
        _;
    }

    function initialize(address owner) public initializer {
        __Ownable_init(owner);
    }

    //TODO share vault
    function share(
        uint256 vaultId,
        address[] memory shareTo
    ) public onlyVaultOwner(vaultId) {}

    function createVault(string memory title, string memory entrypoint) public {
        require(
            vaults[msg.sender].length < _getUserMaxVaultCount(msg.sender),
            "exceeds maximum vault creation"
        );

        uint256 _id = ++totalVaults;
        Vault memory vault = Vault(
            _id,
            msg.sender,
            block.timestamp,
            title,
            entrypoint
        );
        vaults[msg.sender].push(_id);
        vaultMapping[_id] = vault;
        emit VaultCreated(_id, msg.sender);
    }

    function setVaultEntrypoint(
        uint256 vaultId,
        string memory entrypoint
    ) public onlyVaultOwner(vaultId) {
        require(vaultId > 0, "invalid vault id provided");
        require(bytes(entrypoint).length > 0, "entrypoint should not be empty");
        Vault storage vault = vaultMapping[vaultId];
        // TODO uncomment this line👇🏻
        // require(bytes(vault.entrypoint).length == 0, "entrypoint has been set");
        vault.entrypoint = entrypoint;
    }

    function getUserVaults(address addr) public view returns (Vault[] memory) {
        uint256[] memory userOwnedVaultIds = vaults[addr];
        uint256 count = userOwnedVaultIds.length;
        Vault[] memory _vaults = new Vault[](count);
        for (uint256 i = 0; i < count; i++) {
            uint256 _id = userOwnedVaultIds[i];
            _vaults[i] = vaultMapping[_id];
        }
        return _vaults;
    }

    function _getUserMaxVaultCount(
        address addr
    ) private pure returns (uint256) {
        require(addr != address(0x0), "not zero address");
        return DEFAULT_MAX_VAULT_PER_ADDRESS;
    }
}
