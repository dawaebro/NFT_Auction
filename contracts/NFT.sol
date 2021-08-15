pragma solidity ^0.8.6;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";


contract NFT is NFTokenMetadata, Ownable {
    
    uint256 internal tokenCounter = 0;
    
    address public auction;
    
    constructor () {
        nftName = "ART NFT";
        nftSymbol = "ARFT";
        tokenCounter = 0;
    }
    
    function setAuctionAddress(address _auction) public onlyOwner {
        auction = _auction;
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
    onlyOwner
    returns (uint256)
    {
        uint256 mintedTokenId = tokenCounter;
        super._mint(_to, tokenCounter);
        super._setTokenUri(tokenCounter, _uri);
        this.approve(auction, tokenCounter);
        tokenCounter += 1;
        return mintedTokenId;
    }
    
   
}