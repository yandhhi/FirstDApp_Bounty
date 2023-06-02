// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StackUp {

enum playerQuestStatus {
  NOT_JOINED,
  JOINED,
  SUBMITTED
}

struct Quest {
  uint256 questId;
  uint256 numberOfPlayers;
  string title;
  uint8 reward;
  uint256 numberOfRewards;
  uint256 startTime; // Start time of the quest
  uint256 endTime; // End time for the quest
}

address public admin;
uint256 public nextQuestId;
mapping(uint256 => Quest) public quests;
mapping(address => mapping(uint256 => playerQuestStatus)) public playerQuestStatuses;

constructor() {
  admin = msg.sender;
}

function createQuest(
  string calldata title_,
  uint8 reward_,
  uint256 numberOfRewards_,
  uint256 startTime_, //The specified start time of the quest
  uint256 endTime_ //The specified end time of the quest
) external onlyAdmin {
  quests[nextQuestId].questId = nextQuestId;
  quests[nextQuestId].title = title_;
  quests[nextQuestId].reward = reward_;
  quests[nextQuestId].numberOfRewards = numberOfRewards_;
  quests[nextQuestId].startTime = startTime_;  // Set the start time of the newly created quest to the provided startTime_
  quests[nextQuestId].endTime = endTime_;  // Set the end time of the newly created quest to the provided endTime_
  nextQuestId++;
}

function joinQuest(uint256 questId) external questExists(questId) {
  require(
    playerQuestStatuses[msg.sender][questId] ==
    playerQuestStatus.NOT_JOINED,
    "Player has already joined/submitted this quest"
  );
  require(
    block.timestamp >= quests[questId].startTime, // Check if the current time is greater than or equal to the start time of the quest
      "Quest has not started yet"
        );
  require(
    block.timestamp <= quests[questId].endTime, // Check if the current time is less than or equal to the end time of the quest
      "Quest has ended"
        );

  playerQuestStatuses[msg.sender][questId] = playerQuestStatus.JOINED;

  Quest storage thisQuest = quests[questId];
  thisQuest.numberOfPlayers++;
}

function submitQuest(uint256 questId) external questExists(questId) {
  require(
    playerQuestStatuses[msg.sender][questId] ==
    playerQuestStatus.JOINED,
    "Player must first join the quest"
  );
  playerQuestStatuses[msg.sender][questId] = playerQuestStatus.SUBMITTED;
}

function editQuest(
    uint256 questId,
    string calldata newTitle,
    uint8 newReward,
    uint256 newNumberOfRewards,
    uint256 newStartTime,
    uint256 newEndTime
) external questExists(questId) onlyAdmin {
    Quest storage thisQuest = quests[questId];
    // Update the details of the quest with the provided questId
    thisQuest.title = newTitle; // Update the title of the quest
    thisQuest.reward = newReward; // Update the reward of the quest
    thisQuest.numberOfRewards = newNumberOfRewards; // Update the number of rewards of the quest
    thisQuest.startTime = newStartTime; // Update Start time of the quest
    thisQuest.endTime = newEndTime; // Update End time of the quest
}

function deleteQuest(uint256 questId) external questExists(questId) onlyAdmin {
    // Delete the quest with the provided questId
    delete quests[questId];
}

modifier questExists(uint256 questId) {
  require(quests[questId].reward != 0, "Quest does not exist");
  _;
}

modifier onlyAdmin() {
    // Check if the transaction sender is the admin of the contract
    require(msg.sender == admin, "Only the admin can perform this operation");
    _; // Continue with the execution of the function if the sender is the admin
}
}