package io.github.cakelier;

import java.util.Map;
import java.util.Optional;

public class AwardingStrategy {
    public AwardingStrategy() {}

    public Optional<String> award(final Map<String, Integer> bids) {
        return bids.entrySet().stream().max(Map.Entry.comparingByValue()).map(Map.Entry::getKey);
    }
}
