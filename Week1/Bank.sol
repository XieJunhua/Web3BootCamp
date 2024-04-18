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
    receive() external payable {
        save();
        emit Received(msg.sender, msg.value);
    }

    // add money to my account
    function save() private {
        uint256 amount = msg.value;
        address sender = msg.sender;
        uint256 amount_temp = amounts[sender];
        uint256 amount_total = amount_temp + amount;
        amounts[sender] = amount_total;
    }

    function saveMoney() public payable {
        save();

        if (list.length < 3) {
            if (list.length > 0 && list[list.length - 1] == msg.sender) {
                list.pop();
            }
            list.push(msg.sender);
        } else {
            for (uint i = 0; i < list.length; i++) {
                uint256 amount1 = amounts[list[i]];
                if (amount1 < amounts[msg.sender] + msg.value) {
                    list[i] = msg.sender;
                    break;
                }
            }
        }
    }

    function queryMyAccount() public view returns (Result memory) {
        return Result(msg.sender, amounts[msg.sender]);
    }

    function listTop3Accounts() public view returns (address[] memory) {
        return list;
    }

    function withdraw() public {
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
