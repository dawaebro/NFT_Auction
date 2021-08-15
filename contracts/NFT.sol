pragma solidity ^0.8.0;

import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "@0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";


contract NFT is NFTokenMetadata, Ownable {
    
    uint256 internal tokenCounter = 0;
    
    constructor () {
        nftName = "ART NFT";
        nftSymbol = "ARFT";
        tokenCounter = 0;
    }
    
    function setTokenCounter(uint256 _cntr) public {
        tokenCounter = _cntr;
    }
    
    function getTokenCounter() public view returns (uint256) {
        return tokenCounter;
    }

    function disableToken(uint256 _tokenId) public onlyOwner {
        blockedTokenId[_tokenId] = true;
    }
    
    
    /*
    * @dev Mints a new NFT.
    * @param _to The address that will own the minted NFT.
    * @param _tokenId of the NFT to be minted by the msg.sender.
    * @param _uri String representing RFC 3986 URI.
    */
    function mint(
    address _to,
    string calldata _uri
    ) 
    external
    returns (uint256)
    {
        uint256 mintedTokenId = tokenCounter;
        super._mint(_to, tokenCounter);
        super._setTokenUri(tokenCounter, _uri);
        tokenCounter += 1;
        return mintedTokenId;
    }
    
   
}