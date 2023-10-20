!announce.

+!announce : true <-
    !setup;
    !loop.

+!setup : true <-
    makeArtifact("task_board", "io.github.cakelier.TaskBoardSolution", [], TaskBoardId);
    .wait(1000);
    cartago.new_obj("java.util.Random", [42], RandomGenerator);
    +task_board(TaskBoardId);
    +generator(RandomGenerator).

+!loop : task_board(TaskBoardId) & generator(RandomGenerator) <-
    cartago.invoke_obj(RandomGenerator, nextLong(1500), RandomLong);
    Duration = RandomLong + 500;
    cartago.invoke_obj(RandomGenerator, nextInt(3), TaskType);
    println("A new task with type ", TaskType, " will be announced for ", (Duration / 1000), " seconds");
    announce(Duration, TaskType, TaskId, ContractBoardId) [artifact_id(TaskBoardId)];
    +contract_board(TaskId, ContractBoardId);
    focus(ContractBoardId).

+is_open(false) [artifact_id(ContractBoardId)] : task_board(TaskBoardId) & contract_board(TaskId, ContractBoardId) <-
    println("The bidding is now closed, proceeding to choosing the best bidder");
    cartago.new_obj("io.github.cakelier.AwardingStrategy", [], AwardingStrategy);
    getBestBid(AwardingStrategy, BestBid) [artifact_id(ContractBoardId)];
    cartago.invoke_obj(BestBid, isPresent, WinnerExists);
    if (WinnerExists) {
        cartago.invoke_obj(BestBid, get, Winner);
        println("We have a winner, it is bidder ", Winner);
        award(Winner) [artifact_id(ContractBoardId)];
    } else {
        println("No winner won, the task will be left undone");
    };
    stopFocus(ContractBoardId);
    clear(TaskId) [artifact_id(TaskBoardId)];
    .wait(1000);
    !loop.

{ include("$jacamoJar/templates/common-cartago.asl") }
