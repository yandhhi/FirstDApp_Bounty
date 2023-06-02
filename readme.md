## DApp module, expand on the functionalities

### Quest Start and End Time

The inclusion of the **startTime** and **endTime fields** in the Quest structure allows for the representation of the start and end times of each quest. This feature enhances the functionality of the contract by introducing time-bound quests. The **createQuest** and **joinQuest** functions have been modified to verify if the current time falls within the specified range for each quest. Players will be restricted from joining a quest that has not started (startTime) or has already ended (endTime).


### Edit and Delete Quests

The addition of the editQuest and deleteQuest functions empowers the admin to manage quests effectively. The editQuest function enables the admin to modify the details of an existing quest. The admin must provide the questId of the quest to be edited, along with the new values for the title, reward, and number of rewards. On the other hand, the deleteQuest function allows the admin to remove an existing quest. The admin needs to call this function and provide the questId of the quest to be deleted.

### Only Admin

To ensure proper access control, the onlyAdmin modifier has been implemented. This modifier restricts the execution of the **createQuest**, **editQuest**, and **deleteQuest** functions to only the **admin** of the contract. It prevents unauthorized users from performing administrative operations, maintaining the integrity and security of the contract.