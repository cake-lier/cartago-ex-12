package io.github.cakelier;

import cartago.*;

import java.util.HashMap;
import java.util.UUID;

public class TaskBoardSolution extends Artifact {
    private HashMap<String, ArtifactId> pendingTasks;

    private void init() {
        this.pendingTasks = new HashMap<>();
    }

    @OPERATION
    public void announce(
        final long duration,
        final int type,
        final OpFeedbackParam<String> outputTaskId,
        final OpFeedbackParam<ArtifactId> outputBoardId
    ) {
        final var taskId = UUID.randomUUID().toString().replace("-", "_");
        try {
            final var boardId = makeArtifact(
                "contract_net_board_" + taskId,
                "io.github.cakelier.ContractNetBoardSolution",
                new ArtifactConfig(duration)
            );
            defineObsProperty("task", type, boardId);
            this.pendingTasks.put(taskId, boardId);
            outputTaskId.set(taskId);
            outputBoardId.set(boardId);
        } catch (final OperationException e) {
            failed(e.getMessage());
        }
    }

    @OPERATION
    public void clear(final String taskId) {
        try {
            final var boardId = this.pendingTasks.remove(taskId);
            dispose(boardId);
            removeObsPropertyByTemplate("task", null, boardId);
        } catch (final OperationException e) {
            failed(e.getMessage());
        }
    }
}
