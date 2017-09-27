pragma solidity 0.4.17;

library SafeMath {
    
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Splitter {
    
    address public owner;
    address public recipient1;
    address public recipient2;
    
    using SafeMath for uint;
    
    mapping(address => uint) public recipients;
    
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
        require(_recipient1 != _recipient2 && msg.sender != _recipient1 && msg.sender != _recipient2);
        owner = msg.sender;
        recipient1 = _recipient1;
        recipient2 = _recipient2;
        recipients[recipient1] = 0;
        recipients[recipient2] = 0;
    }
    
    function split() public payable isOwner {
        // Make sure frontend accept wei only.
        // forced integer when divided by 2.
        require(msg.value > 0);
        uint halfValue = msg.value.div(2);
        recipients[recipient1] = recipients[recipient1].add(halfValue);
        recipients[recipient2] = recipients[recipient2].add(halfValue);
                
        LogSplit(msg.sender, msg.value);
    }
    
    function setRecipient(address _origin, address _new) public isOwner returns (bool){
        require(_origin != address(0) && _new != address(0));
        require(_origin != _new);
        uint tranferValue = recipients[_origin];
        delete recipients[_origin];

        if (_origin == recipient1) {
            recipient1 = _new;
        }
        else if (_origin == recipient2) {
            recipient2 = _new;
        }
        else {
            revert();
        }
        recipients[_new] = tranferValue;
        return true;
    }
		
    function changeOwner(address _newOwner) public isOwner returns (uint) {
        owner = newOwner;
    }
    
    function withdraw(address _recipient) public isNotOwner returns (bool) {
        require(msg.sender == _recipient);
        uint tranferValue = recipients[_recipient];
        recipients[_recipient] = 0;
        _recipient.transfer(tranferValue);
        LogWithdraw(_recipient, tranferValue);
        return true;
    }
    
    function getContractBalance() public view returns (uint) {
        return this.balance;    
    }
    
    function kill() public isOwner {
        selfdestruct(owner);
    }
}
