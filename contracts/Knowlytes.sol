// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "base64-sol/base64.sol";

contract Knowlytes is ERC721, ERC721Enumerable, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter; 

    Counters.Counter private _tokenIdCounter;

    uint256 public cost  = 0.000005 ether;
    uint256 public constant maxSupply = 1111;
    bool public paused = false;
    string[] private  Hat=["Hat1","Hat2","Hat3","Hat4","Hat5","Hat6","Hat7","Hat8","Hat9","Hat10","Hat11","Hat12","Hat13","Hat14"]; // Hat 14
    string[] private Jacket=["Jacket1","Jacket2","Jacket3","Jacket4","Jacket5","Jacket6","Jacket7","Jacket8","Jacket9","Jacket10","Jacket11","Jacket12","Jacket13","Jacket14"]; // Jacket14
    string[] private Hair=["Hair1","Hair2","Hair3","Hair4","Hair5","Hair6","Hair7","Hair8","Hair9","Hair10","Hair11","Hair12","Hair13"]; // Hair 13
    string[] private Nose=["Nose1","Nose2","Nose3","Nose4","Nose5","Nose6","Nose7","Nose8"]; // Nose 8
    string[] private Glass=["Glass1","Glass2","Glass3","Glass4","Glass5","Glass6","Glass7","Glass8"]; // 8 Glass
    string[] private Ear=["Ear1","Ear2","Ear3","Ear4","Ear5","Ear6","Ear7","Ear8"]; // 8 Ears
    string[] private Background = ["Blue","Conference","Construction","Hospital","Restaurant","Yellow","Green"]; //7 Background;

    struct NFTAttributes{
        uint256 hatIndex; 
        uint256 jacketIndex;
        uint256 hairIndex;
        uint256 noseIndex;
        uint256 glassIndex;
        uint256 earIndex;
        uint256 bgIndex;
    }

    struct NFTDetails{
        NFTAttributes currentDetails;
        NFTAttributes selectedDetails;
        bool isSelected;
    }

    mapping(uint256 => NFTDetails) public nftdetails;

    event MintedNFT(uint256 indexed _tokenId,string bg,string hat,string jacket,string hair,string nose,string glass,string ear);

    constructor() ERC721("Knowlytes", "$KNOW") {}


    function mintKnowlytes() public payable{
        uint256 supply = totalSupply();
        require(msg.sender!=address(0),"Zero Address Can't Mint");
        require(!paused,"Contract Paused");
        require(supply <= maxSupply,"All NFT's Minted");
        if(msg.sender!=owner()){
            require(msg.value >= cost,"Invalid Amount"); // Non Owner Account Need to Pay
        }
        _tokenIdCounter.increment(); // Increment Counter
        uint256 tokenId = _tokenIdCounter.current(); //  Token ID
        NFTDetails storage nft = nftdetails[tokenId];
        nft.currentDetails.hatIndex = generateRandom(msg.sender,Hat.length);
        nft.currentDetails.jacketIndex = generateRandom(msg.sender,Jacket.length);
        nft.currentDetails.hairIndex = generateRandom(msg.sender,Hair.length);
        nft.currentDetails.noseIndex = generateRandom(msg.sender,Nose.length);
        nft.currentDetails.glassIndex = generateRandom(msg.sender,Glass.length);
        nft.currentDetails.earIndex = generateRandom(msg.sender,Ear.length);
        nft.currentDetails.bgIndex = generateRandom(msg.sender,Background.length);

        _safeMint(msg.sender,tokenId);

        emit MintedNFT(tokenId,
        Hat[nft.currentDetails.hatIndex],
        Jacket[nft.currentDetails.jacketIndex],
        Hair[nft.currentDetails.hairIndex],
        Nose[nft.currentDetails.noseIndex],
        Glass[nft.currentDetails.glassIndex],
        Ear[nft.currentDetails.earIndex],
        Background[nft.currentDetails.bgIndex]
        );



    }



    function tokenURI(uint256 tokenId)public view override returns (string memory){
        require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
        NFTDetails memory nft = nftdetails[tokenId];

        string memory name = string(abi.encodePacked("Knowlytes #",tokenId.toString()));
        string memory description = "Knowledge is Power";
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked('{"name":"', name, '", "description":"', description, '", "image": "", "attributes": [{"trait_type": "Background", "value": "',Background[nft.currentDetails.bgIndex], '" },{"trait_type": "Body", "value": "Body" }, {"trait_type": "Hat", "value": "',Hat[nft.currentDetails.hatIndex], '" },  {"trait_type": "Jacket", "value": "', Jacket[nft.currentDetails.jacketIndex], '" }, {"trait_type": "Hair", "value": "', Hair[nft.currentDetails.hairIndex], '" },{"trait_type": "Nose", "value": "',Nose[nft.currentDetails.noseIndex], '" },{"trait_type": "Glass", "value": "',Glass[nft.currentDetails.glassIndex], '" },{"trait_type": "Ear", "value": "',Ear[nft.currentDetails.earIndex], '" }] }')
                    )
                )
            )
        );
     }



    function generateRandom(address _account,uint256 range) internal view returns(uint256){
        uint startToken = 0;
        return uint(keccak256(abi.encodePacked(block.timestamp,_account,block.difficulty,startToken))) % range; 
    }

    // only Owner
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }


    function withdraw()public payable onlyOwner{
        (bool success,)= payable(owner()).call{value:address(this).balance}("");
        require(success,"Tx Failed");
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}