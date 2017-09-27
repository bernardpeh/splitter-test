pragma solidity 0.4.17;

contract Splitter {
    
    address public owner;
    address public recipient1;
    address public recipient2;
    
    mapping(address => uint) recipients;
    
    modifier isOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier isNotOwner {
        require(msg.sender != owner);
        _;
    }
    
    event LogSplit(address sender, uint value);
    
    event LogWithdraw(address sender, uint value);
    
    function Splitter(address _recipient1, address _recipient2) public {
        owner = msg.sender;
        recipient1 = _recipient1;
        recipient2 = _recipient2;
        recipients[owner] = 0;
        recipients[recipient1] = 0;
        recipients[recipient2] = 0;
    }
    
    function split() public payable isOwner {
        // check msg.value is divisable
        uint halfValue = msg.value/2;
        recipients[owner] += msg.value; 
        recipients[recipient1] += halfValue;
        recipients[recipient2] += halfValue;
        LogSplit(msg.sender, msg.value);
    }
    
    function setRecipient(address _origin, address _new) public isOwner returns (bool){
        
        require(_origin != _new);
        uint tranferValue = recipients[_origin];
        delete recipients[_origin];
        
        if (_origin == recipient1) {
            recipient1 = _new;
        }
        if (_origin == recipient2) {
            recipient2 = _new;
        }
        recipients[_new] = tranferValue;
        return true;
    }
    
    function getBalance(address _recipient) public constant returns (uint) {
        return recipients[_recipient];
    }
    
    function withdraw(address _recipient) public isNotOwner returns (bool) {
        // empty value first
        uint tranferValue = recipients[_recipient];
        recipients[_recipient] = 0;
        _recipient.transfer(tranferValue);
        LogWithdraw(_recipient, tranferValue);
        return true;
    }
    
    function kill() public isOwner {
        selfdestruct(owner);
    }
}
