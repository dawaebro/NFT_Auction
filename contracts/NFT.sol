pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";


contract NFT is NFTokenMetadata, Ownable {
    
    // mapping (uint256 => uint256) internal priceOfToken;
    // mapping (uint256 => address) winnerOfToken;
    uint256 internal tokenCounter = 0;
    
    constructor () {
        nftName = "Synth NFT";
        nftSymbol = "SYN";
        tokenCounter = 0;
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
        tokenCounter += 1;
        return mintedTokenId;
    }
    
    /*
    * @dev Mints a new NFT.
    * @param _to The address that will own the minted NFT.
    * @param _tokenId of the NFT to be minted by the msg.sender.
    * @param _uri String representing RFC 3986 URI.
    */
    // function setWinnerAndPrice(
    // uint256 _tokenId,
    // uint256 _winningBidAmount,
    // address _winningAddress
    // ) 
    // external
    // onlyOwner
    // {
    //     require(_winningBidAmount != 0, "Amount cannot be zero");
    //     require(_winningAddress != address(0), "Invalid Address");
        
    //     priceOfToken[_tokenId] = _winningBidAmount;
    //     winnerOfToken[_tokenId] = _winningAddress;
    // }
    
    function claimToken(uint256 _tokenId) public payable {
        require(msg.value > priceOfToken[_tokenId], "Please pay ETH = Bid Amount");
        require(msg.sender == winnerOfToken[_tokenId], "Only winner can claim the amount");
        
        // Transfer Money to Owner
        address payable owner = payable(idToOwner[_tokenId]);
        this.safeTransferFrom(idToOwner[_tokenId], msg.sender, _tokenId, "");
        owner.transfer(msg.value);
        
    }
}