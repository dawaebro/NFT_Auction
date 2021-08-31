pragma solidity ^0.8.0;

import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "@0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";


contract NFT is NFTokenMetadata, Ownable {
    
    uint256 internal tokenCounter = 0;
    mapping(uint256 => address) public originalOwner;
    uint256 public royalty = 10; // 10 % for creator/originalOwner
    
    constructor () {
        nftName = "ART NFT";
        nftSymbol = "ARFT";
        tokenCounter = 0;
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
        originalOwner[mintedTokenId] = _to;
        tokenCounter += 1;
        return mintedTokenId;
    }
    
   
}