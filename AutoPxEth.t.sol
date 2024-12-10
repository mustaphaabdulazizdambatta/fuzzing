// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import "../src/AutoPxEth.sol";
import {MockERC20} from "../MockERC20.sol";

contract AutoPxEthTest is Test {
    AutoPxEth autoPxEth;
    MockERC20 mockERC20;

    // Setup function to deploy the contracts
    function setUp() external {
        // Deploy MockERC20 and AutoPxEth contracts
        mockERC20 = new MockERC20();
        address feeRecipientAddress = address(this);
        autoPxEth = new AutoPxEth(address(mockERC20), feeRecipientAddress);
        
        // Target the contract for invariants
        targetContract(address(autoPxEth));
    }

 

    // Test for modifying the withdrawal penalty directly through storage manipulation
    function testBreakInvariantByStorage() public {
        console.log("Breaking invariant by modifying storage...");

        // Slot for withdrawalPenalty is 16
        bytes32 slot = bytes32(uint256(16));

        // Log the current value before modification
        uint256 currentPenalty = autoPxEth.withdrawalPenalty();
        console.log("Before modification, withdrawal penalty: %d", currentPenalty);

        // Modify the storage slot to change the withdrawal penalty to an arbitrary value (e.g., 50,000)
        vm.store(address(autoPxEth), slot, bytes32(uint256(50_000)));

        // Log the new value after modification
        uint256 modifiedPenalty = autoPxEth.withdrawalPenalty();
        console.log("After modification, withdrawal penalty: %d", modifiedPenalty);

        // Assert the modified value
        assertEq(modifiedPenalty, 50_000);
    }

    function testBreakInvariantByStorageplatformFee() public {
        console.log("Breaking invariant by modifying storage...");

        // Slot for platformFee is 17
        bytes32 slot = bytes32(uint256(17));

        // Log the current value before modification
        uint256 currentplatformFee = autoPxEth.platformFee();
        console.log("Before modification, platformFee: %d", currentplatformFee);

        // Modify the storage slot to change the platformFee to an arbitrary value (e.g., 50,000)
        vm.store(address(autoPxEth), slot, bytes32(uint256(50_000)));

        // Log the new value after modification
        uint256 modifiedplatformFee = autoPxEth.platformFee();
        console.log("After modification, platformFee: %d", modifiedplatformFee);

        // Assert the modified value
        assertEq(modifiedplatformFee, 50_000);
    }
}
