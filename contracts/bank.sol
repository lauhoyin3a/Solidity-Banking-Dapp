pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";


contract Bank{
    address owner;
    bytes32[] public whitelistedSymbols; //array of token symbols that allow being deposited and withdrawn from this contract
    mapping(bytes32 => address) public whitelistedTokens; //address
    mapping(address => mapping(bytes32=> uint256)) public balances; // address : the deposited wallet, bytes32: symbol of the token, uint256: number of that token thats been deposited


    constructor(){
        owner=msg.sender;
    }
    
    function whitelistedToken(bytes32 symbol, address tokenAddress) external{
        require(msg.sender == owner, "Only Owner can use this function");

        whitelistedSymbols.push(symbol);
        whitelistedTokens[symbol]= tokenAddress;
    }
   function getWhitelistedTokenAddress(bytes32 symbol) external view returns(address){
        return whitelistedTokens[symbol];
    }

    receive() external payable{
        balances[msg.sender]['Eth'] += msg.value;
        }
            
    function withdrawEther(uint amount) external {
        require(balances[msg.sender]['Eth'] >= amount, 'Insufficient funds');
        balances[msg.sender]['Eth'] -= amount;
        payable(msg.sender).call{value: amount}("");
            }


function depositTokens(uint256 amount, bytes32 symbol) external{
    balances[msg.sender][symbol] += amount;
    IERC20(whitelistedTokens[symbol]).transferFrom(msg.sender, address(this), amount);
}

function withdrawTokens(uint256 amount, bytes32 symbol) external{

require(balances[msg.sender][symbol] >= amount, 'Insufficient funds');

balances[msg.sender][symbol] -= amount;
 IERC20(whitelistedTokens[symbol]).transfer( msg.sender,amount);
}

function getTokenBalance(bytes32 symbol) external view returns(uint256){
    return balances[msg.sender][symbol];
}

}