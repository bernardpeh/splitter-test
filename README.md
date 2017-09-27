Simple contract with basic business rules.

1. Person A is the owner of the contract and defines recipient1 and recipient2 when deploying the contract.
2. Everytime person A sends ether to the contract, it will be split 50/50 between both recipients
3. Onwer can selfdestruct the contract and get all unused ether back.
4. Owner has the authority to change owner and assign 2 new recipients.
5. Input data needs safety check.
4. 
