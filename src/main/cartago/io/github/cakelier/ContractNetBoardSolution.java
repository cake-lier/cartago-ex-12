package io.github.cakelier;

import cartago.Artifact;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.OpFeedbackParam;

import java.util.HashMap;
import java.util.Optional;

public class ContractNetBoardSolution extends Artifact {
    private boolean isOpen;
    private HashMap<String, Integer> bids;

    private void init(final long duration) {
        this.isOpen = true;
        this.bids = new HashMap<>();
        defineObsProperty("is_open", true);
        execInternalOp("checkDeadline", duration);
    }

    @INTERNAL_OPERATION
    private void checkDeadline(final long duration) {
        await_time(duration);
        this.isOpen = false;
        updateObsProperty("is_open", false);
    }

    @OPERATION
    public void bid(final String bidder, final int offer) {
        if (this.isOpen) {
            this.bids.put(bidder, offer);
        } else {
            failed("You are bidding too late, the offer will be rejected");
        }
    }

    @OPERATION
    public void getBestBid(final AwardingStrategy awardingStrategy, final OpFeedbackParam<Optional<String>> bestBid) {
        if (!this.isOpen) {
            bestBid.set(awardingStrategy.award(this.bids));
        } else {
            failed("You are getting the bids too early, the bidding is still in progress");
        }
    }

    @OPERATION
    public void award(final String bidderId) {
        defineObsProperty("winner", bidderId);
    }
}
