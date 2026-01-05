    function test_SplitFeeMathError() public {
        uint256 amount = 100e18;
        uint256 period = 100;
        uint256 startTime = block.timestamp;

        token.transfer(address(tvsManager), amount);

        // 1. Setup NFT
        vm.prank(address(alignerz));
        uint256 nftId = nft.mint(bidders[1]);
        vm.prank(address(alignerz));
        tvsManager.setTVS(nftId, amount, period, startTime, token, 0, false, 0);

        // 2. Warp to 40% of vesting and claim
        vm.warp(startTime + 40);
        vm.prank(bidders[1]);
        tvsManager.claimTokens(nftId);
        // 3. Set split fee to 2% and split 100%
        vm.prank(owner);
        tvsManager.setSplitFeeRate(200);
        uint256[] memory percentages = new uint256[](1);
        percentages[0] = 10000; // 100%
        vm.prank(bidders[1]);
        (, uint256[] memory newIds) = tvsManager.splitTVS(percentages, nftId);
        uint256 nextId = newIds[0];
        TVSManager.Allocation memory alloc = tvsManager.getAllocationOf(nextId);

        // Fee on unclaimed 60 is 1.2. New amount = 98.8.
        assertEq(alloc.amounts[0], 98.8e18);
        assertEq(alloc.claimedAmounts[0], 40e18);
        // 4. Warp to 50% of original vesting (10 seconds later)
        vm.warp(startTime + 50);
        uint256 claimable = tvsManager.getClaimableAmount(alloc, 0);
        // Current calculation: (50/100 * 98.8) - 40 = 9.4 tokens.
        // If scaled correctly, it should be 9.8 tokens.
        console.log("Claimable at t=50: %s (Expected ~9.8e18)", claimable);

        // This confirms the user lost 0.4 tokens due to unscaled claimedAmount
        assertEq(claimable, 9.4e18);
    }
