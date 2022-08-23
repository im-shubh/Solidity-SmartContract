// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract NftStake is Ownable{
    IERC721 public parentNFT;
    IERC20 public rewardToken ;

    struct StakeNft {
        uint256 tokenId;
        uint256 timestamp;
    }
    struct Reward {
        uint256 tokenId;
        uint256 timestamp;
    }

    // map staker address to stake details
     mapping(address => uint256) public _nftIDCounter;
     mapping(address => mapping(uint256 => StakeNft )) public _stakesNft;
     
     // For Reward distribution
     mapping(address => uint256) public _rewardCounter;
     mapping(address => mapping(uint256 => Reward )) public _reward;


  

    constructor() {
        parentNFT = IERC721(0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47); // Change it to your NFT contract addr         
        rewardToken = IERC20(0x7b96aF9Bd211cBf6BA5b0dd53aa61Dc5806b6AcE); // Change it to your ERC20 contract addr         
    }

    function stake(uint256 _tokenId) public {
        require(parentNFT.ownerOf(_tokenId)==msg.sender,"You're not owner of this token.");
        address staker = msg.sender;
        _nftIDCounter[staker] = _nftIDCounter[staker] + 1;
        _stakesNft[staker][_nftIDCounter[staker]] = StakeNft(_tokenId,block.timestamp);
        // _stakesNft[msg.sender] = Stake(_tokenId,block.timestamp); 
        // parentNFT.safeTransferFrom(msg.sender, address(this), _tokenId, _amount, "0x00");
        parentNFT.transferFrom(msg.sender,address(this),_tokenId);
    } 

    function unstake(uint256 tokenId) external {
        address staker = msg.sender;
        require(_nftIDCounter[staker] > 0,"You did not stake any NFT's");
        uint256 counter = _nftIDCounter[staker];
        for(uint256 i = 1; i <= counter ; i++){
        uint256 time = (block.timestamp - _stakesNft[msg.sender][i].timestamp);
        uint256 id = _stakesNft[staker][i].tokenId;

        if(time !=0 && time < 172800 && tokenId == id){
         parentNFT.transferFrom(address(this),staker,tokenId); 
         delete _stakesNft[msg.sender][i];

        }
        if(time !=0 && time >= 172800 && tokenId == id){
         parentNFT.transferFrom(address(this),staker,tokenId); 
         rewardToken.transfer(staker,20 * 10 **18);
         delete _stakesNft[msg.sender][i];
        }
        if(i == counter && time == 0){
            revert ("You already Unstake all NFTs");
        }
        break;
        }
    }    

    function claimRewards () external {
        address staker = msg.sender;
        require(_nftIDCounter[staker] > 0,"You did not stake any NFT's");
        uint256 counter = _nftIDCounter[staker];
        for(uint256 i = 1; i <= counter ; i++){
        uint256 time = (block.timestamp - _stakesNft[msg.sender][i].timestamp);
        uint256 _tokenId = _stakesNft[staker][i].tokenId;
        uint256 totalStakingTime = time/86400;

        if(time !=0 && time >= 172800 && _rewardCounter[staker] <= 0 ){

        if(totalStakingTime >= 3 && totalStakingTime < 4){

        _rewardCounter[staker] = _rewardCounter[staker] + 1;
        _reward[staker][_rewardCounter[staker]] = Reward(_tokenId,block.timestamp);
         rewardToken.transfer(staker,totalStakingTime*10 * 10 **18);

        }

        _rewardCounter[staker] = _rewardCounter[staker] + 1;
        _reward[staker][_rewardCounter[staker]] = Reward(_tokenId,block.timestamp);
         rewardToken.transfer(staker,10 * 10 **18);

        }
        uint256 rewardcounter = _rewardCounter[staker];

        if(time !=0 && time >= 172800 && _rewardCounter[staker] > 0){

        for(uint256 j = 1; j <= rewardcounter; j++){

            uint256 rewardTime = _reward[staker][j].timestamp;
            uint256 totalRewardTime = rewardTime/86400;

            if(totalStakingTime > 2 && rewardTime >= 172800){

                _rewardCounter[staker] = _rewardCounter[staker] + 1;
                _reward[staker][_rewardCounter[staker]] = Reward(_tokenId,block.timestamp);
                rewardToken.transfer(staker,totalRewardTime*10 * 10 **18);
                delete _reward[msg.sender][j];
            }
        }
        }

        if(i == counter && time == 0){
            revert ("You are not eligible for Reward");
        }
        continue;

        }
    }

    function getStakingTime(uint256 tokenId) external view returns (uint256) {
        uint256 stakingTime;
        address staker = msg.sender;
        require(_nftIDCounter[staker] > 0,"You did not stake any NFT's");
        uint256 counter = _nftIDCounter[staker];

        for(uint256 i = 1; i <= counter ; i++){
        uint256 time = _stakesNft[staker][i].timestamp;

        if(time !=0 && tokenId == _stakesNft[staker][i].tokenId ){
          stakingTime = (block.timestamp - _stakesNft[msg.sender][i].timestamp);
        }
        if(i == counter && time == 0){
            revert ("You already Unstake all NFTs");
        }
        continue;

        }
        return stakingTime;
    }
    function getStakedTokenId(address staker) external view returns(uint256[] memory){
       
        uint256 index = 0;
        uint256 size = 0;

        require(_nftIDCounter[staker] > 0,"You did not stake any NFT's");

        uint256 counter = _nftIDCounter[staker];

        for(uint256 j = 1; j <= counter ; j++){
        uint256 time = _stakesNft[staker][j].timestamp;

        if(time !=0 ){
           size++;
        }
        }
        uint256[] memory stakeIds = new uint[](size);

        for(uint256 i = 1; i <= counter ; i++){
            uint256 time = _stakesNft[staker][i].timestamp;

        if(time !=0 ){
            stakeIds[index] = _stakesNft[staker][i].tokenId;
            index++;
        }
        if(i == counter && time == 0){
            revert ("You already Unstake all NFTs");
        }
        continue;
        }
        return stakeIds;
    }
}
