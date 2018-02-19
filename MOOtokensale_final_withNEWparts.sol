pragma solidity ^0.4.16;
// v03



/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */

  modifier onlyOwner(){
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }
}

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
      */
  function transfer(address _to, uint256 _value) public returns (bool){
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
  function balanceOf(address _owner) public constant returns (uint256 balance) {
    return balances[_owner];
  }
}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {
  mapping (address => mapping (address => uint256)) internal allowed;

  /**
  * @dev Transfer tokens from one address to another
  * @param _from address The address which you want to send tokens from
  * @param _to address The address which you want to transfer to
  * @param _value uint256 the amout of tokens to be transfered
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    balances[_to] = balances[_to].add(_value);
    balances[_from] = balances[_from].sub(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
  * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
  * @param _spender The address which will spend the funds.
  * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {

    // To change the approve amount you first have to reduce the addresses`
    //  allowance to zero by calling `approve(_spender, 0)` if it is not
    //  already 0 to mitigate the race condition described here:
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
  * @dev Function to check the amount of tokens that an owner allowed to a spender.
  * @param _owner address The address which owns the funds.
    * @param _spender address The address which will spend the funds.
    * @return A uint256 specifing the amount of tokens still avaible for the spender.
   */

  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }
}

/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */
contract MintableToken is StandardToken, Ownable {

  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;

  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  /**
  * @dev Function to mint tokens
  * @param _to The address that will recieve the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Transfer(0X0, _to, _amount);
    return true;
  }

  /**
  * @dev Function to stop minting new tokens.
  * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner public returns (bool) {
    mintingFinished = true;
    MintFinished();
    return true;
  }
}

contract MooToken is MintableToken {
  // Coin Properties
  string public name = "MOO token";
  string public symbol = "XMOO";
  uint256 public decimals = 18;

  // Special propeties
  bool public tradingStarted = false;

  /**
  * @dev modifier that throws if trading has not started yet
   */
  modifier hasStartedTrading() {
    require(tradingStarted);
    _;
  }

  /**
  * @dev Allows the owner to enable the trading. This can not be undone
  */
  function startTrading() public onlyOwner {
    tradingStarted = true;
  }

  /**
  * @dev Allows anyone to transfer the MOO tokens once trading has started
  * @param _to the recipient address of the tokens.
  * @param _value number of tokens to be transfered.
   */
  function transfer(address _to, uint _value) hasStartedTrading public returns (bool) {
    return super.transfer(_to, _value);
  }

  /**
  * @dev Allows anyone to transfer the MOO tokens once trading has started
  * @param _from address The address which you want to send tokens from
  * @param _to address The address which you want to transfer to
  * @param _value uint the amout of tokens to be transfered
   */
  function transferFrom(address _from, address _to, uint _value) hasStartedTrading public returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }

  function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
    oddToken.transfer(owner, amount);
  }
}


contract MooTokenSale is Ownable {

  using SafeMath for uint256;

  // The token being sold
  MooToken public token;
  uint256 public decimals;
  uint256 public oneCoin;

  // start and end block where investments are allowed 
  uint256 public presale_startTimestamp;
  uint256 public presale_endTimestamp;

  // start and end block where investments are allowed 
  uint256 public publicsale_startTimestamp;
  uint256 public publicsale_endTimestamp;

  // address where funds are collected
  address public multiSig;

  function setWallet(address _newWallet) public onlyOwner {
    multiSig = _newWallet;
  } 

  uint256 public rate; // how many token units a buyer gets per wei
  uint256 public minContribution = 0.0001 ether;  // minimum contributio to participate in tokensale
  uint256 public maxContribution = 200000 ether;  // default limit to tokens that the users can buy
  uint256 public tokensOfTeamAndAdvisors;

  // amount of raised money in wei
  uint256 public weiRaised;

  // amount of raised tokens
  uint256 public tokenRaised;

  // maximum amount of tokens being created
  uint256 public maxTokens;

  // maximum amount of tokens for sale
  uint256 public tokensForSale;  

  // number of participants in presale
  uint256 public numberOfContributors = 0;

  //  for whitelist
  address public cs;
  //  for whitelist AND placement
  address public Admin;

  //  for rate
  uint public basicRate;
 

  // switch on/off the authorisation , default: false- off 
  bool    public freeForAll = false;

  mapping (address => bool) public authorised; // just to annoy the heck out of americans
  mapping (address => uint) adminCallMintToTeamCount; // count to admin only once can call MintToTeamAndAdvisors

  event TokenPurchase(address indexed purchaser, uint256 amount, uint256 _tokens);
  event TokenPlaced(address indexed beneficiary, uint256 _tokens);
  event SaleClosed();
  event TradingStarted();
  event Closed();

  function MooTokenSale() public {
    presale_startTimestamp =  1516896000;
        // 1516896000 converts to Friday January 26, 2018 00:00:00 (am) in time zone Asia/Singapore (+08)
    //presale_endTimestamp = 1519358400;
        // 1519358400 converts to Friday February 23, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08
    publicsale_startTimestamp = 1519876800;
        // 1519876800 converts to Thursday March 01, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08)
    presale_endTimestamp = publicsale_startTimestamp;
        // in case we havent break    
    publicsale_endTimestamp = 1522468800; 
        // 1522468800 converts to Saturday March 31, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08)
    multiSig = 0x90420B8aef42F856a0AFB4FFBfaA57405FB190f3;
   
    token = new MooToken();
    decimals = token.decimals();
    oneCoin = 10 ** decimals;
    maxTokens = 500 * (10**6) * oneCoin;
    tokensForSale = 234847984 * oneCoin;
    basicRate = 2800;
    tokensOfTeamAndAdvisors = 65152016 * oneCoin;  // it was missing the onecoin
  }


  /**
  * @dev Calculates the rate with bonus in the publis sale
    */
  function setTier(uint _basicRate) internal {
    
    if (tokenRaised <= 10000000 * oneCoin) {
      rate = _basicRate  *11/10;
    } else if (tokenRaised <= 20000000 * oneCoin) {
      rate = _basicRate *1075/1000;
    } else if (tokenRaised <= 30000000 * oneCoin) {
      rate = _basicRate *105/100;
    } else {
      rate = _basicRate ;
    }
  }

  // @return true if crowdsale event has ended
  function hasEnded() public constant returns (bool) {
    if (now > publicsale_endTimestamp)
      return true; // if  the time is over
    if (tokenRaised >= tokensForSale)
      return true; // if we reach the tokensForSale 
    return false;
 }
  
  // @dev throws if person sending is not contract Admin or cs role
  modifier onlyCSorAdmin() {
    require((msg.sender == Admin) || (msg.sender==cs));
    _;
  }
  modifier onlyAdmin() {
    require(msg.sender == Admin);
    _;
  }

  /**
  * @dev throws if person sending is not authorised or sends nothing or we are out of time
  */
  modifier onlyAuthorised() {
    require (authorised[msg.sender] || freeForAll);
    require (now >= presale_startTimestamp && now < publicsale_endTimestamp);
    require (!(hasEnded()));
    require (multiSig != 0x0);
    require (msg.value > 1 finney);
    require(tokensForSale > tokenRaised); // check we are not over the number of tokensForSale
    _;
  }

  /**
  * @dev authorise an account to participate
  */
  function authoriseAccount(address whom) onlyCSorAdmin public {
    authorised[whom] = true;
  }

  /**
  * @dev authorise a lot of accounts in one go
  */
  function authoriseManyAccounts(address[] many) onlyCSorAdmin public {
    for (uint256 i = 0; i < many.length; i++) {
      authorised[many[i]] = true;
    }
  }

  /**
  * @dev ban an account from participation (default)
  */
  function blockAccount(address whom) onlyCSorAdmin public {
    authorised[whom] = false;
  }

  /**
  * @dev set a new CS representative
  */
  function setCS(address newCS) onlyOwner public {
    cs = newCS;
  }

  /**
  * @dev set a new Admin representative
  */
  function setAdmin(address newAdmin) onlyOwner public {
          Admin = newAdmin;
  }

  /**
  * @dev set a new Rate BE CAREFULL: when we calculate the bonus better if we have'nt remainder 
  */
  function setRate(uint newRate) onlyAdmin public {
    //require( now < presale_startTimestamp);
    require( 0 < newRate && newRate < 5000);
    basicRate = newRate;
  }

/**
  * @dev  only Admin can send tokens manually
  */
  function placeTokens(address beneficiary, uint256 _tokens) onlyAdmin public {
    //require(tokenRaised.add(_tokens) <= tokensForSale); // we dont want to overmint
    require(_tokens != 0);
    require(!hasEnded());
    if (token.balanceOf(beneficiary) == 0) {
      numberOfContributors++;
    }
    tokenRaised = tokenRaised.add(_tokens); // so we can go slightly over
    token.mint(beneficiary, _tokens);
    TokenPlaced(beneficiary, _tokens);
  }

  // low level token purchase function
  function buyTokens(address beneficiary, uint256 amount) onlyAuthorised internal {
      
    // check we are in pre sale , bonus 25%
    if (now <= presale_endTimestamp) {
      rate = basicRate  * 5/4;
      minContribution = 50 ether;
    // we are in publicsale bonus depends on the sold out tokens. we set the rate in the setTier
    } else {
     setTier(basicRate);
     minContribution = 0.15 ether;
     maxContribution = 600 ether;
    }

    //check minimum and maximum amount
    require(msg.value >= minContribution);
    require(msg.value <= maxContribution);
    
    // Calculate token amount to be purchased    
    uint256 tokens = amount.mul(rate);
    //require(tokenRaised.add(tokens) <= tokensForSale); //f dont want to overminti

    // update state
    weiRaised = weiRaised.add(amount);
    if (token.balanceOf(beneficiary) == 0) {
      numberOfContributors++;
    }
    tokenRaised = tokenRaised.add(tokens); // so we can go slightly over
    token.mint(beneficiary, tokens);
    TokenPurchase(beneficiary, amount, tokens);
    multiSig.transfer(this.balance); // better in case any other ether ends up here
  }

  // transfer ownership of the token to the owner of the presale contract
  function finishSale() public onlyOwner {
    require(hasEnded());
    // assign the rest of the 300 M tokens to the reserve
    uint unassigned;    
    if(tokensForSale > tokenRaised) {
      unassigned  = tokensForSale.sub(tokenRaised);
      tokenRaised = tokenRaised.add(unassigned);
      token.mint(multiSig,unassigned);
      TokenPlaced(multiSig,unassigned);
    }
    SaleClosed();
    token.startTrading(); 
    TradingStarted();
    // from now everyone can trade the tokens  and the owner of the tokencontract stay the salecontract
 }
 
/**
*****************************************************************************************
*****************************************************************************************
*    SPECIAL PART START
*****************************************************************************************
*****************************************************************************************
  * @dev only Admin can mint once the given amount in the given time
  * tokensOfTeamAndAdvisors was given by consumer
  * multiSig was given by consumer
*****************************************************************************************
*****************************************************************************************
 */
   function mintToTeamAndAdvisors() public onlyAdmin {
     require(hasEnded());
     require(adminCallMintToTeamCount[msg.sender] == 0); // count to admin only once can call MintToTeamAndAdvisors
     require(1535644800 <= now  && now <= 1535731200);  // Admin have 24h to call this function
      //1535644800 converts to Friday August 31, 2018 00:00:00 (am) in time zone Asia/Singapore (+08)
      //1535731200 converts to Saturday September 01, 2018 00:00:00 (am) in time zone Asia/Singapore (+08)
     adminCallMintToTeamCount[msg.sender]++; 
     tokenRaised = tokenRaised.add(tokensOfTeamAndAdvisors);
     token.mint(multiSig,tokensOfTeamAndAdvisors);
     TokenPlaced(multiSig, tokensOfTeamAndAdvisors);
 }
 /**
*****************************************************************************************
*****************************************************************************************
  * @dev only Admin can mint from "SaleClosed" to "Closed" 
  * _tokens given by client (limit if we reach the maxTokens)
  * multiSig was given by client
*****************************************************************************************
*****************************************************************************************
 */ 
   function afterSaleMinting(uint _tokens) public onlyAdmin {
     require(hasEnded());
     require(tokenRaised.add(_tokens) <= maxTokens);  // we dont want to overmint
     tokenRaised = tokenRaised.add(_tokens);
     token.mint(multiSig,_tokens);
     TokenPlaced(multiSig, _tokens);
 }  
/**
*****************************************************************************************
*****************************************************************************************
  * @dev only Owner can call after the sale
  * unassigned , all missing tokens will be minted
  * multiSig was given by client
  * finish minting and transfer ownership of token
*****************************************************************************************
*****************************************************************************************
 */
   function close() public onlyOwner {
     require(1535731200 <= now);  // only after the Aug31
     uint unassigned;
     if( maxTokens > tokenRaised) {
      unassigned  = maxTokens.sub(tokenRaised);
      tokenRaised = tokenRaised.add(unassigned);
      token.mint(multiSig,unassigned);
      TokenPlaced(multiSig,unassigned);
      multiSig.transfer(this.balance); // just in case if we have ether in the contarct
     }
     token.finishMinting();
     token.transferOwnership(owner);
     Closed();
  }
/**
*****************************************************************************************
*****************************************************************************************
  * END OF THE SPECIAL PART
*****************************************************************************************
*****************************************************************************************
 */


  // fallback function can be used to buy tokens
  function () public payable {
    buyTokens(msg.sender, msg.value);
  }

  // emergency if the contarct get ERC20 tokens
  function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
    oddToken.transfer(owner, amount);
  }
}



