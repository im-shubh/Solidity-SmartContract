// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "base64-sol/base64.sol";
//import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Georim is ERC721, ReentrancyGuard, Ownable {
    using Counters for Counters.Counter;
    using Address for address;
    using Strings for uint256;
   // using Strings for uint8;

    Counters.Counter private _tokenIdCounter;
     string private _contractURI;
    IERC20 public rimuletoken;
    uint256 public tilePrice;
    string public _baseTokenURI="https://tile.openstreetmap.org/";
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) _tokenURI;

    struct Tile {
        address Owner;
        uint256 x;
        uint256 y;
        uint256 zoom;
        string longitude;
        string latitude;
        uint256 mintTime;
        bool isMinted;
        uint256 tokenId;
    }
 
    // Tile Structure
    mapping(uint256 => mapping(uint256 => mapping(uint256 => Tile))) tileDetails;
    mapping(uint256 => Tile) TileKeys;

    /* Custom Error */
    error isAlreadyMinted(uint256 x, uint256 y, uint256 zoom);

    constructor(IERC20 _rimuleContract) ERC721("Georim", "GEORIM") {
        rimuletoken = _rimuleContract;
        tilePrice = 1 * 10**6;
        setContractURI();
       
    }

    event CustomMint(address indexed buyer, uint256 tokenId, uint256 time);
    event UserInfo(
        address indexed buyer,
        uint256 x,
        uint256 y,
        uint256 z,
        string longitude,
        string latitude
    );

    function safeMint(
        uint256 _x,
        uint256 _y,
        uint256 _zoom,
        string calldata _longitude,
        string calldata _latitude
    ) external nonReentrant {
        address buyer = msg.sender; // Buyer
        require(_x > 0 && _x <= 2**18 - 1, "Invalid X");
        require(_y > 0 && _y <= 2**18 - 1, "Invalid Y");

        Tile storage tileInfo = tileDetails[_x][_y][_zoom];
       
        if (tileInfo.isMinted == true) revert isAlreadyMinted(_x, _y, _zoom);
        rimuletoken.transferFrom(msg.sender, address(this), tilePrice);
        uint256 tokenId = _tokenIdCounter.current();
         Tile storage t= TileKeys[tokenId];
      
        // Store the Details
        t.x=_x;
        t.y=_y;
        t.zoom=_zoom;
        t.tokenId=tokenId;
        tileInfo.Owner = buyer;
        tileInfo.x = _x;
        tileInfo.y = _y;
        tileInfo.zoom = _zoom;
        tileInfo.longitude = _longitude;
        tileInfo.latitude = _latitude;
        tileInfo.mintTime = block.timestamp;
        tileInfo.isMinted = true;
        tileInfo.tokenId=tokenId;
        _tokenIdCounter.increment();
      //  _tokenURI[tokenId];
        _safeMint(buyer, tokenId);
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        // construct metdata from tokenId
        return constructTokenURI(tokenId);
    }

    
     function setContractURI() internal onlyOwner() {
           string memory name ="RimulationNFT";
        string memory description = string(abi.encodePacked(" Welcome to the Rimulation World "));
       
        _contractURI = string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(
                bytes(
                    abi.encodePacked('{"name":"', name, '", "description":"', description, '" }'
                    
                    )
                )
            )
        ));
    }
      function contractURI() public view returns (string memory) {
        return _contractURI;
    }

        function constructTokenURI(uint256 tokenId)
        private
         view
        returns (string memory)
    { 
         Tile storage t= TileKeys[tokenId];  
         uint256 Tilex=t.x;
         uint256 Tiley= t.y;
         uint256 Tilez= t.zoom;
        string memory randomTokenURI = string(abi.encodePacked(_baseTokenURI,Tilez.toString(), '/',Tilex.toString(),'/',Tiley.toString(),".png")); 
        string memory name ="Rimulation";
        string memory description = string(abi.encodePacked("Image : ",randomTokenURI," Credit : ","www.openstreetmap.org"));
        string memory valueOfx = string(abi.encodePacked("X - ",Tilex.toString()));
        string memory valueOfy = string(abi.encodePacked("Y - ",Tiley.toString()));
        string memory valueOfz = string(abi.encodePacked("Z - ",Tilez.toString()));

        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked('{"name":"', name, '", "description":"', description, '", "image": "', randomTokenURI, '", "attributes": [ {"trait_type": "Tile Coordinates", "value": "', valueOfx, '" },  {"trait_type": "Tile Coordinates", "value": "', valueOfy, '" }, {"trait_type": "Tile Coordinates", "value": "', valueOfz, '" }] }')
                    )
                )
            )
        );
    }
      function getTileInfo(
        uint256 _x,
        uint256 _y,
        uint256 _zoom
    )
        public
        view
        returns (
            //address,
            uint256,
            uint256,
            uint256,
            string memory,
            string memory,
            uint256,
            bool,
            uint256
        )
    {
        Tile memory t = tileDetails[_x][_y][_zoom];
        return (
          //  t.owner,
            t.x,
            t.y,
            t.zoom,
            t.longitude,
            t.latitude,
            t.mintTime,
            t.isMinted,
            t.tokenId
        );
    }
}