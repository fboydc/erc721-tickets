pragma solidity ^0.4.24;

import "../node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract TicketRepository is ERC721Token {
    constructor(string _name, string _symbol) public ERC721Token(_name, _symbol){}

    function emitTicket(address _to, uint256 _tokenId) public{
        super._mint(_to, _tokenId);
    }

}

