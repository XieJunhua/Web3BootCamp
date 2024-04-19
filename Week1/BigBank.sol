// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;


error WithdrawerNotManager();

contract Bank {
    address manager_address = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    mapping(address => uint256) amounts;
    address[] list;

    struct Result {
        address addre;
        uint256 amount;

    }

    event Received(address, uint);
    receive() external payable virtual  {
        save();
        emit Received(msg.sender, msg.value);
    } 

    //add money to my account
    function save() internal virtual  {
        uint256 amount = msg.value;
        address sender = msg.sender;
        uint256 amount_temp = amounts[sender];
        uint256 amount_total = amount_temp + amount;
        amounts[sender] = amount_total;
        if(list.length < 3 ) { 
            if (list.length > 0 && list[list.length - 1] == sender) {
                list.pop();
            }
            list.push(sender);
        } else {
            // find the minimum value and the index
            uint256 index = 0;
            uint256 minValue = amounts[list[0]]; 
            for (uint i = 1; i < list.length; i++) {
                if (amounts[list[i]] <= minValue) {
                    index = i;
                    minValue = amounts[list[i]]; 
                }
            } 

            // compare the minimum value and the value of current account
            if (amounts[sender] >= minValue) {
                list[index] = sender;
            }
        }
    }

    function saveMoney() payable public {
        save();            
    }

    
    function queryMyAccount()public view returns (Result memory) {
        return Result(msg.sender, amounts[msg.sender]);
    }

    function listTop3Accounts()public view returns (address[] memory) {
        return list;
    }

    function withdraw()public virtual {
        address sender = msg.sender;
        
        if (sender == manager_address) {
            payable(sender).transfer(address(this).balance);
        } else {
            revert WithdrawerNotManager();
        }
    }

    function queryAllBalance() public view returns (uint256) {
        return address(this).balance;
    }

}

// feference to:  https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
abstract contract Ownable{
    address private _owner;

    error OwnableInvalidOwner(address owner);

    constructor(address initialOwner) {
        _transferOwnership(initialOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        _owner = newOwner;
    }

    // modifier 
    modifier onlyOwner() {
        require(_owner == msg.sender);
        _;
    }
    
}

contract BigBank is Bank, Ownable {

    constructor(address initialOwner) Ownable(initialOwner){
        // 兼容老的Bank代码的权限控制； 新的权限控制在Ownable中进行
        manager_address = initialOwner;
    }

    modifier receiveThreshold{
        require(msg.value > 0.001 ether);
        _;
    }

    function save() internal override receiveThreshold {
        super.save();
    }

    function test_modifier() public payable  receiveThreshold {
        super.queryAllBalance();
    }

    function withdraw() public override  onlyOwner{
        super.withdraw();

    }

    
}



