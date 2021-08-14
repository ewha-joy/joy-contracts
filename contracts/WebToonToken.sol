pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";

contract WebToonToken is ERC721Full {
  struct WebToon {
    string title;
    string episode;
    string artist;
    string dateCreated;
    uint256 order;
    string series;
  }

  
  mapping (uint256 => WebToon) WebToons;
  mapping (bytes => uint256) webtoonIDsCreated;
  mapping (string => uint256[]) Series;
  mapping (uint256 => uint256) public tokenPrice;

  constructor(string memory name, string memory symbol) ERC721Full(name, symbol) public {}

  function mintWTT(
    string memory _title,
    string memory _episode,
    string memory _artist,
    string memory _dateCreated,
    string memory _series
  )
    public
  {
    uint256 _order = Series[_series].length.add(1);
    bytes memory checksum = abi.encodePacked(_series, _order);

    require(webtoonIDsCreated[checksum] == 0, "Token has already been created");
    //require(Series[_series].length < _order, "_order has error");

    uint256 tokenId = totalSupply().add(1);
    WebToons[tokenId] = WebToon(_title, _episode, _artist, _dateCreated, _order, _series);
    Series[_series].push(tokenId);
    webtoonIDsCreated[checksum] = tokenId;

    _mint(msg.sender, tokenId);
  }

  function getWTT(uint256 _tokenId) public view returns( string memory, string memory, string memory, string memory, uint256, string memory) {
    return ( WebToons[_tokenId].title, WebToons[_tokenId].episode, WebToons[_tokenId].artist, WebToons[_tokenId].dateCreated, WebToons[_tokenId].order, WebToons[_tokenId].series);
  }

  function isTokenAlreadyCreated(string memory _series, uint256 _order) public view returns (bool) {
    return webtoonIDsCreated[abi.encodePacked(_series, _order)] != 0 ? true : false;
  }

  function getEpiCount(string memory _series) public view returns( uint256 ) {
    return Series[_series].length;
  }

  function getSeries(string memory _series) public view returns( uint256[] memory ) {
    return Series[_series];
  }  

  function removeWTT(uint _tokenId) external {
    _burn(_tokenId);
  }
}
