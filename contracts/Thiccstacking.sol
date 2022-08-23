// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Staking is ERC1155Receiver {
    using Address for address;
    using SafeMath for uint256;

    ERC1155 public erc1155;
    IERC20 public ierc20;
    IERC20 public token;
    address private owner;

    constructor() {
        owner= _msgSender();
    }

    struct StakeNft {

        uint256 tokenId;
        uint256 amount;
        uint256 startTimestamp;
    }
    struct StakeThicc {
        uint256 amount;
        uint256 startTimestamp;
        


    }
    
    // This is for nft. 
    mapping(address => uint256) public _nftIDCounter;
    mapping(address => mapping(uint256 => StakeNft )) public _stakesNft;
   
    // This is for Thicc 
    mapping(address => uint256) public _thiccIDCounter;
    mapping(address => mapping(uint256 => StakeThicc )) public _stakeThicc;

    
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    modifier onlyOwner() {
        require(
            owner== _msgSender(),
            "Ownable: caller is not the owner"
        );
        _;
    }
    
    function SetNFTContract(address _nftContract) public onlyOwner {
         erc1155= ERC1155(_nftContract);
    }

    function SetTHICCcontract(address _thiccContract) public onlyOwner {
         ierc20 = IERC20(_thiccContract);
    }
    
    // This function is to stake nft.
    function stakeNFT(uint256 _tokenId) external {
        require(erc1155.balanceOf(msg.sender,_tokenId) == 1);
        address staker=msg.sender;
        uint256 amount= 1;
        _nftIDCounter[staker] = _nftIDCounter[staker] + 1;
         _stakesNft[staker][_nftIDCounter[staker]] = StakeNft(
        _tokenId,amount,block.timestamp);
        
        erc1155.safeTransferFrom(msg.sender, address(this), _tokenId, amount, "0x00");
    } 
    // This function is to unstake nft.
    // function unstakeNFT() external {
        // require(_stakesNft[msg.sender].amount >=1);
        
        // uint256 amount=1;

        // erc1155.safeTransferFrom(address(this), msg.sender, _stakesNft[msg.sender].tokenId[0], amount, "0x00");
        // delete _stakesNft[msg.sender];
    // } 
     
    function stakeTHICC(uint256 _amount) public {
        address staker=msg.sender;
        require(ierc20.balanceOf(staker) >= 0,"You have insufficient THICC.");
        _thiccIDCounter[staker] = _thiccIDCounter[staker] + 1;

        _stakeThicc[staker][_thiccIDCounter[staker]] = StakeThicc(
            _amount,block.timestamp);
            ierc20.transferFrom(staker, address(this), _amount);
    }

    // This function is used to stake THICC ERC20 Token.
    function unstakeTHICC() external {
        address staker=msg.sender;
        require(_thiccIDCounter[staker] >= 1,"You don't stake yet." );
        uint256 totalCountstake = _thiccIDCounter[staker];
        

        for(uint256 i=1; i <= totalCountstake;i++){
            uint256 stakeTime= _stakeThicc[staker][i].startTimestamp;
            uint256 stakeAmount=_stakeThicc[staker][i].amount;
            uint256 sevenDays= stakeTime + 1 minutes;
            uint256 fifteenDays= stakeTime + 3 minutes;
            uint256 thirtyDays= stakeTime + 5 minutes;
           
           if( block.timestamp > sevenDays  && block.timestamp < fifteenDays){
               
               uint256  commissionPercentage=100;
               uint256 commissionby=1000;
               uint256 rewardAmount= stakeAmount *commissionPercentage /commissionby;
               stakeAmount+=rewardAmount;
               ierc20.transferFrom(address(this),staker,stakeAmount);
            }
            if(block.timestamp > fifteenDays && block.timestamp < thirtyDays  ){
              
               
               uint256 commissionPercentage=250;
               uint256 commissionby=1000;

               uint256 rewardAmount= stakeAmount * commissionPercentage/commissionby;
               stakeAmount+=rewardAmount;
               ierc20.transferFrom(address(this),msg.sender,stakeAmount);
            }
            if( block.timestamp > thirtyDays ) {
               
                uint256 commissionPercentage=700;
                uint256 commissionby=1000;

               uint256 rewardAmount= stakeAmount * commissionPercentage/commissionby;
               stakeAmount+=rewardAmount;
               ierc20.transferFrom(address(this),msg.sender,stakeAmount);
            }
            ierc20.transferFrom(address(this),staker,stakeAmount);
            
    
        }
    }






    function ContractThiccBalance() external view onlyOwner returns(uint256){
        return ierc20.balanceOf(address(this));
    }





    
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155Received.selector;
    }


    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

    receive() external payable {}

}
