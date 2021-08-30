pragma solidity ^0.8.0;

import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "@0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";


contract NFT is NFTokenMetadata, Ownable {
    
    uint256 internal tokenCounter = 0;
    mapping(uint256 => address) public originalOwner;
    mapping(uint256 => uint256) public royalties;
    
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
    uint256 _royalty,
    string calldata _uri
    ) 
    external
    returns (uint256)
    {
        require(_royalty > 10 && _royalty < 30, "Royalty can be between 10 and 30 % only");
        uint256 mintedTokenId = tokenCounter;
        super._mint(_to, tokenCounter);
        super._setTokenUri(tokenCounter, _uri);
        originalOwner[mintedTokenId] = _to;
        royalties[mintedTokenId] = _royalty;
        tokenCounter += 1;
        return mintedTokenId;
    }
    
   
}