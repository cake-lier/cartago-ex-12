!bid.

+!bid : true <-
    !discoverTaskBoard(TaskBoardId);
    focus(TaskBoardId);
    cartago.new_obj("java.util.Random", [42], RandomGenerator);
    +generator(RandomGenerator).

+task(TaskType, ContractBoardId) :
    accepted_task_types(TaskTypesList)
    & .member(TaskType, TaskTypesList)
    & generator(RandomGenerator)
    & bidder_id(BidderId) <-
    focus(ContractBoardId);
    cartago.invoke_obj(RandomGenerator, nextInt(10), RandomInt);
    Offer = RandomInt + 1;
    println("I, bidder ", BidderId, ", bid ", Offer, "€");
    bid(BidderId, Offer) [artifact_id(ContractBoardId)].

-!task(_, _) : bidder_id(BidderId) <-
    println("I, bidder ", BidderId, ", submitted my bid too late!").

+winner(BidderId) : bidder_id(BidderId) <-
    println("I, bidder ", BidderId, ", won the bidding!").

+winner(BidderId) : not bidder_id(BidderId) & bidder_id(MyBidderId) <-
    println("I, bidder ", MyBidderId, ", lost the bidding!").

+!discoverTaskBoard(TaskBoardId) : true <-
    lookupArtifact("task_board", TaskBoardId).

-!discoverTaskBoard(TaskBoardId) : true <-
    !discoverTaskBoard(TaskBoardId).

{ include("$jacamoJar/templates/common-cartago.asl") }
