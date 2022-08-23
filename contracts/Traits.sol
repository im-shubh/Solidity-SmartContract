// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "base64-sol/base64.sol";
// // import "https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/master/contracts/BokkyPooBahsDateTimeLibrary.sol";

// contract ChangeTraits is Ownable,ERC721 {
//     // using BokkyPooBahsDateTimeLibrary for uint;
//     using Strings for uint256;
//     ERC721 public knowToken;                                                
    
//      mapping(string =>uint256) public _traitsCount;
//      mapping(string =>bool) public _freezeTraits;

//      mapping(uint256 => NftDetails) public nftdetails;

//      struct NftAtribute{
//         uint256 hat;
//         uint256 jacket;
//         uint256 hair;
//         uint256 nose;
//         uint256 glasses;
//         uint256 ear;
//      }

//      struct NftDetails{
//         NftAtribute currentDetails;
//         NftAtribute selectedDetails;
//         bool isSelected;
//      }
     

//     constructor(ERC721 _knowToken){
//         knowToken=  _knowToken;
//     }

//     // HAT3 < 5% freeze Hat3

//     string[] private Hat=["Hat1","Hat2","Hat3","Hat4","Hat5","Hat6"];
//     string[] private Jacket=["Jacket1","Jacket2","Jacket3","Jacket4","Jacket5","Jacket6"];
//     string[] private Hair=["Hair1","Hair2","Hair3","Hair4","Hair5","Hair6"];
//     string[] private Nose=["Nose1","Nose2","Nose3","Nose4","Nose5","Nose6"];
//     string[] private Glass=["Glass1","Glass2","Glass3","Glass4","Glass5","Glass6"];
//     string[] private Ear=["Ear1","Ear2","Ear3","Ear4","Ear5","Ear6"];

//     struct Traits {
//         string traits; 
//         uint256 lastMonth;
//         uint256 lastYear; 
//     }

//     mapping(uint256=> Traits) public userTraits;

//     // function getYear(uint timestamp) public pure returns (uint year) {
//     //     year = BokkyPooBahsDateTimeLibrary.getYear(timestamp);
//     // }
//     // function getMonth(uint timestamp) public pure returns (uint month) {
//     //     month = BokkyPooBahsDateTimeLibrary.getMonth(timestamp);
//     // }
//     // function getDay(uint timestamp) public pure returns (uint day) {
//     //     day = BokkyPooBahsDateTimeLibrary.getDay(timestamp);
//     // }
//     // function getMinute(uint timestamp) public pure returns (uint minute) {
//     //     minute = BokkyPooBahsDateTimeLibrary.getMinute(timestamp);
//     // }
//     //  function getHour(uint timestamp) public pure returns (uint hour) {
//     //     hour = BokkyPooBahsDateTimeLibrary.getHour(timestamp);
//     // }
//     //  function getDaysInMonth(uint timestamp) public pure returns (uint daysInMonth) {
//     //     daysInMonth = BokkyPooBahsDateTimeLibrary.getDaysInMonth(timestamp);
//     // }
//     // function timestampToDate(uint timestamp) public pure returns (uint year, uint month, uint day) {
//     //     (year, month, day) = BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
//     // }

//     // function changeTraits(uint256 _id, uint8 _type, string memory _traits) external {
//     //     // require(knowToken.ownerOf(_id) == msg.sender,"Owner is not valid.");
//     //     require(_type >=1 && _type <=6,"Invalid traits type.");
//     //     Traits storage t = userTraits[_id];

//     //     uint256 lastMonths= t.lastMonth;
//     //     uint256 lastYear= t.lastYear;
//     //     uint256 currentMonth=getMonth(block.timestamp);
//     //     uint256 currentYear= getYear(block.timestamp);
//     //     // uint256 currentMinute=getMinute(block.timestamp);
//     //     // uint256 currentHour= getHour(block.timestamp);
//     //     // uint256 date = currentMinute + currentHour;

//     //     bool checkTraits= checkAvailableTraits(_type,_traits);
//     //     require(checkTraits,"invalid Input");


//     //     require((lastMonths != currentMonth ) || (lastYear !=currentYear) ,"Already changed Traits in a month." );
        
//     //     t.traits=_traits; 
//     //     t.lastMonth= currentMonth; 
//     //     t.lastYear= currentYear;
//     //     _traitsCount[_traits]++;
    

//     // }

//     // function checkAvailableTraits(uint8 _type, string memory _traits) public view returns(bool){
//     //     if(_type==1){
//     //          for(uint8 i=0; i < Hat.length; i++){
//     //             if(keccak256(abi.encodePacked(Hat[i])) == keccak256(abi.encodePacked(_traits))){
//     //                 break;
//     //             }
//     //             if(i== Hat.length-1){
//     //                 return false;
//     //             }
//     //         }
//     //     }
//     //     if(_type==2){
//     //          for(uint8 i=0; i < Hair.length; i++){
//     //             if(keccak256(abi.encodePacked(Hair[i])) == keccak256(abi.encodePacked(_traits))){
//     //                 break;
//     //             }
//     //             if(i== Hair.length-1){
//     //                 return false;
//     //             }
//     //         }
//     //     }
//     //     if(_type==3){
//     //         for(uint8 i=0; i < Glass.length; i++){
//     //             if(keccak256(abi.encodePacked(Glass[i])) == keccak256(abi.encodePacked(_traits))){
//     //                 break;
//     //             }
//     //             if(i== Glass.length-1){
//     //                 return false;
//     //             }
//     //         }
//     //     }
//     //     if(_type==4){
//     //         for(uint8 i=0; i < Jacket.length; i++){
//     //             if(keccak256(abi.encodePacked(Jacket[i])) == keccak256(abi.encodePacked(_traits))){
//     //                 break;
//     //             }
//     //             if(i== Glass.length-1){
//     //                 return false;
//     //             }
//     //         }
//     //     }
//     //     if(_type==5){
//     //         for(uint8 i=0; i < Nose.length; i++){
//     //             if(keccak256(abi.encodePacked(Nose[i])) == keccak256(abi.encodePacked(_traits))){
//     //                 break;
//     //             }
//     //             if(i== Nose.length-1){
//     //                 return false;
//     //             }
//     //         }
//     //     }
//     //     if(_type==6){
//     //         for(uint8 i=0; i < Ear.length; i++){
//     //             if(keccak256(abi.encodePacked(Ear[i])) == keccak256(abi.encodePacked(_traits))){
//     //                 break;
//     //             }
//     //             if(i== Ear.length-1){
//     //                 return false;
//     //             }
//     //         }
//     //     }
//     //     return true;
//     // }


//     function getUserTraits(uint256 _ids) external view returns(string memory){
//         Traits memory t = userTraits[_ids];
//         return(t.traits);
//     }

//     function getRare() public returns(string memory){}

//     function random(string memory input) public pure returns (uint256) {
//         return uint256(keccak256(abi.encodePacked(input)));
//     }



//     function tokenURI(uint256 _tokenId) public  override  view returns(string memory){
//         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token"); // Check for Token ID Exist or Not

//         string memory name = "Knowlytes";
//         string memory baseURI = 'data:application/json;base64,';
//         string memory description="";


//         return string(
//             abi.encodePacked(
//                 baseURI,
//                 Base64.encode(
//                     bytes(
//                         abi.encodePacked(
//                             '{"name":"', name,
//                              '", "description":"', description,
//                               '", "image": "', "",
//                                '", "attributes": [ {"trait_type": "Hat Type", "value": "',Hat[0] ,
//                                 '" },  {"trait_type": "Jacket Type", "value": "', Jacket[0],
//                                  '" }, {"trait_type": "Hair Type", "value": "', Hair[0],
//                                   '" }] }'
//                         )
//                     )

//                 )
//             )
//         );
//     } 



// }