pragma solidity 0.5.9;

interface DaiToken {
    function transfer(address dst, uint256 wad) external returns (bool);
    function balanceOf(address guy) external view returns (uint);
}

contract MyContract {
    DaiToken daitoken;
    address owner;
    bool claimed = false;
    
    event Log(
        string logText
    );
    
    event LogHash(
        string logText,
        bytes32 hash
    );
    
    event LogAddess(
        address addy
    );
    
    constructor() public {
		daitoken = DaiToken(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
		owner = msg.sender;
	}
    
    // meatloaf
    bytes32 public answerHash = 0xee434ac1aada81d42c2291a7c2b88756c2f233a52b49e22a8c03b1cd30401532;

    function submit(string memory answer) public {
        if (claimed) {
            emit Log('Sorry, funds already claimed! Brain over man!');
        }
        bytes32 _inputHash = keccak256(abi.encode(answer));
        emit LogHash('Comparing hash', _inputHash);
        bool _isCorrect = _inputHash == answerHash;

        if (_isCorrect) {
            uint256 withdraw_amount = daitoken.balanceOf(address(this));
            require(
                withdraw_amount > 0,
			    "Insufficient balance"
		    );
            emit Log('Correct answer! Sending tokens!');
            claimed = true;
            daitoken.transfer(msg.sender, withdraw_amount);
        } else {
            emit Log('Incorrect answer!');
        }
    }
    
    function isClaimed() public view returns (bool) {
        return claimed;
    }
    
    function () external payable {
        emit Log("Got funds!");
    }
}
