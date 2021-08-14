pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";

contract TokenSales {

  ERC721Full public nftAddress;
  mapping (uint256 => uint256) public tokenPrice;
  
  constructor(address _tokenAddress) public {
    nftAddress = ERC721Full(_tokenAddress);
  }

  //nft 매도
  function setForSale(uint256 _tokenId, uint256 _price) public {
    address tokenOwner = nftAddress.ownerOf(_tokenId);
    require(tokenOwner == msg.sender, "caller is not token owner");
    require(_price > 0, "price is zero or lower");
    require(nftAddress.isApprovedForAll(tokenOwner, address(this)), "token owner did not approve TokenSales contract");
    tokenPrice[_tokenId] = _price;
  }

  //nft 매수
  function purchaseToken(uint256 _tokenId) public payable {
    uint256 price = tokenPrice[_tokenId];
    address tokenSeller = nftAddress.ownerOf(_tokenId);
    require(msg.value >= price, "caller sent klay lower than price");
    require(msg.sender != tokenSeller, "caller is token seller");
    address payable payableTokenSeller = address(uint160(tokenSeller));
    payableTokenSeller.transfer(msg.value);
    nftAddress.safeTransferFrom(tokenSeller, msg.sender, _tokenId);
    tokenPrice[_tokenId] = 0;
  }

  //nft 매도 전체 취소 (토큰 price 0으로 초기화)
  function removeTokenOnSale(uint256[] memory tokenIds) public {
    require(tokenIds.length > 0, "tokenIds is empty");
    for (uint i = 0; i < tokenIds.length; i++) {
      uint256 tokenId = tokenIds[i];
      address tokenSeller = nftAddress.ownerOf(tokenId);
      require(msg.sender == tokenSeller, "caller is not token seller");
      tokenPrice[tokenId] = 0;
    }
  }

  //nft 매도 부분 승인
  function setForSaleEach(uint256 _tokenId, uint256 _price) public {
    address tokenOwner = nftAddress.ownerOf(_tokenId);
    require(tokenOwner == msg.sender, "caller is not token owner");
    require(_price > 0, "price is zero or lower");
    //require(nftAddress.getApproved(_tokenId) == address(this), "2token owner did not approve TokenSales contract");
    require(nftAddress.getApproved(_tokenId) == address(this), "token owner did not approve TokenSales contract");
    tokenPrice[_tokenId] = _price;
  }

  //nft 매도 부분 취소 (토큰 price 0으로 초기화)
  function removeTokenOnSaleEach(uint256 _tokenId) public {
    require(_tokenId > 0, "tokenId is null");
    address tokenSeller = nftAddress.ownerOf(_tokenId);
    require(msg.sender == tokenSeller, "caller is not token seller");
    tokenPrice[_tokenId] = 0;
  }
}
