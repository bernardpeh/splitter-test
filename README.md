Simple contract with basic business rules.

1. Owner of the contract defines recipient1 and recipient2 when deploying the contract.
2. Everytime person A sends ether to the contract, it will be split 50/50 between both recipients
3. Owner can selfdestruct the contract and get all unused ether back.
4. Owner has the authority to change owner and assign 2 new recipients.
5. Input data needs safety check.
