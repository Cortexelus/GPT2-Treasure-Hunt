pragma solidity 0.5.9;

interface ChaiToken {
    function transfer(address dst, uint256 wad) external returns (bool);
    function balanceOf(address guy) external view returns (uint);
}

// This contract holds some amount of Chai as a prize (owner sends it to the contract after deploy)
// Users submit their answer with submit function 
// The answer is checked against a hash, and if the hashes match, the user wins the prize
// If the prize has won, the contract is marked as claimed = true

contract MyContract {
    ChaiToken chaitoken;
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
		chaitoken = ChaiToken(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
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
            uint256 withdraw_amount = chaitoken.balanceOf(address(this));
            require(
                withdraw_amount > 0,
			    "Insufficient balance"
		    );
            emit Log('Correct answer! Sending tokens!');
            claimed = true;
            chaitoken.transfer(msg.sender, withdraw_amount);
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
