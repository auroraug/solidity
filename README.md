```shell
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "https://github.com/auroraug/ERC721-alter/contracts/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SoulBoudToken is ERC721URIStorage, Verifier{
    
//允许mint
mapping (address => bool) mintStatus;
    function changeMintStatus(address _to,bool _mintStatus)public onlyVerifier(msg.sender){
        mintStatus[_to] = _mintStatus;
    }
    using Strings for uint256;

    using Counters for Counters.Counter;

    uint256 public  max_supply = 10000;

    string public  uriIpfs = "";
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("SoulBoudToken", "SBT") {}

    function changeuriIpfs(string memory _uri)public onlyOwner{
        uriIpfs = _uri;
        max_supply = 10000;
    }

    function safeMint() public {
        require(mintStatus[msg.sender] == true,"You can't mint the SBT");
        require(_tokenIdCounter.current() <= max_supply);
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uriIpfs);
        max_supply -= 1;
    }
}

```
