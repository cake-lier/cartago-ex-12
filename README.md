# CArtAgO by exercises — Exercise 12 — Contract Net Protocol using Artifacts

In this exercise...
You are left alone!
Now you have all the tools you need for creating a project leveraging the CArtAgO platform.
You will be given only the files you need to implement and nothing else,
except for the "AwardingStrategy" class explained later.

We ask you to implement some agents obeying the "[contract net](http://www.fipa.org/specs/fipa00029/SC00029H.html)"
protocol.
It's a standardized interaction protocol for agents thought for situations where you have an "announcer"
agent who wants some task to be done,
but there are more "bidder" agents that can satisfy its request.
So, the "announcer" agent starts an auction to find the "bidder" that can be best suited for executing the task.
The "bidder" agents submit their bids to the auction and, after the auction duration time has elapsed,
the best bidder is chosen and awarded.

The announcer agent should create a "TaskBoard" artifact, to be used for announcing new tasks (and new auctions).
The announcer agent generates a new task auction deciding randomly a duration and a task type for the task.
The type is an integer value between zero and two included.
This is done through a dedicated "announce"
operation which takes these two values as input parameters
and returns the task id and the artifact id of a "ContractNetBoard" artifact.
It focuses the artifact through its id and then saves those two output parameters for later use.

The TaskBoard "announce" operation should create a new "ContractNetBoard" artifact,
so it creates a new one for each auction.
Then, it defines a new observable property "task" to be perceived from the bidder agents,
containing the type and the board artifact id.
The task is now kept as a pending one, it will be removed at the end of the auction.

The bidder agent should initialize itself searching for the "TaskBoard" artifact,
to focus it and receive the aforementioned "task" observable property updates.
When a new update is received, it is checked if the type is inside the list of acceptable types for the agent and,
if so, the corresponding plan is executed.
The "ContractNetBoard" artifact is focused on receiving its updates on the auction, and then a new offer is placed.
The offer value is a random integer between one and ten,
and it is placed alongside the bidder id as an offer with a "bid" operation on the artifact.

The "ContractNetBoard" artifact should be initialized with the duration time of the auction.
In this way, it can set the state of the auction to "open" and expose it to the agents with an observable property.
It then starts an internal operation that waits for the duration time to be elapsed
to update the observable property to "closed,"
ending the auction.
The announcer agent will wait until the property state change to collect the best bid with the "getBestBid" operation,
explaining why it focused the "ContractNetBoard" in the first place.
The "bid" operation must be allowed only when the state of the auction is "open"
and the "getBestBid" must be allowed only when the state is closed.
Note also that even if it is the announcer to ask the artifact for the best bid,
it is the agent that decides the right strategy for choosing the best one,
passing an "AwardingStrategy" instance to the action.

Once getting the best bid, the announcer agent announces to the bidding agent it is the winner.
It does this through an "award" operation on the "ContractNetBoard" artifact that takes the id of the bidder to award.
This operation then creates a new "winner" observable property with the bidder id,
so bidder agents can perceive it and then tell if they are the winner or not.

After awarding the winner, the auction is terminated,
so the corresponding artifact can be "unfocused" by the announcer and each bidder.
The announcer then asks for the deletion of the assigned task from the "TaskBoard" artifact via the "clear" operation. 
This operation takes the id of the task and removes it from the pending ones,
removes the observable property related to it, and disposes the artifact responsible for its auction.
After waiting some time, the announcer agent loops and starts a new auction.

## Solution

All solution files are marked with the "solution" suffix, don't open them before solving the exercise!