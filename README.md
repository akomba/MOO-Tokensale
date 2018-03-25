# MOO-Tokensale

Opening time:

  presale_startTimestamp =  1516896000;
        // 1516896000 converts to Friday January 26, 2018 00:00:00 (am) in time zone Asia/Singapore (+08)
    presale_endTimestamp = 1522209600;
        //1522209600 converts to Wednesday March 28, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08)
    publicsale_startTimestamp = 1522382400;
        //  1522382400 converts to Friday March 30, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08)
    publicsale_endTimestamp = 1525060800; 
    // 1525060800 converts to Monday April 30, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08)

## Presale and Public Sale (fallback function)

* min purchase depends on the date( presale- 50 Ehter and publicsale - 0.15 Ether)
* max purchase depends on the date( presale- 1000 Ether and publicsale . 600 Ether)
* max tokens what a buyer can buy default is = max contributon * bacis rate , the Admin can set this value to call `setMaxTokenCap()`
* pre-authorised

## Bonus

* presale: 25%
* pudlicsale: depends on the sold tokens
	- 0 -10.000.000 : 10%
	- 10.000.000 - 20.000.000 : 7,5%
	- 20.000.000 - 30.000.000 : 5%
	- 30.000.000 -            : 0%

## Private Sale (placeTokens)

* by Admin user
* tokens minted on demand before or while sale is active.
* call `placeTokens()` function with address of beneficiary
  and number of tokens ( its in wei!!!)

## Authorisation

* by Admin user or cs user 
* can approve or block
* call `authoriseAccount()` / `authoriseManyAccounts()` / `blockAccount()`

## changable Rate 

* only if it neccessary
* by Admin user
* take care the rate set the bonus: only without reminder!
* basic rate = 2800 
* call `setRate()` with the new Rate

************************************
*     NEW PART OF THE CONTRACT     *
************************************

## Finishing the sale (owner) 

* dont passes control of token back to the owner
* startTrading ( called from the contract)
* minting the unsold tokens 
* call `finishSale()` 

## Minting after the sale 

* by Admin User
* if the sale is end
* till reach the maxTokens minus reserved amount of Team and Advisors
* call `afterSaleMinting()` with the number of tokens

## Minting tokens for Team and Advisors

* by Admin User
* only during the given Period ( 31.Aug .2018 / 24h)
* only once can call
* if the Admin never call it, the reserved tokens would be minted in CLOSE phase
* call `mintToTeamAndAdvisors()`

## Closing the process (owner)

* after the mintToTeamAndAdvisors time is end
* minting every missing tokens to maxTokens
* passes control of token back to the owner
* finish the minting
* call `close()`

############## update ####################

* time update
* presale new limit :  maxcontribution = 1000 ether 

* use the new standardToken with increase-, and decreaseApproval
* use serious limit in placeToken() and buyToken() functions and we can't overmint the tokens
* we dont solve the fairly allocate the last few tokens, 
(so you need to call the functions with the expected amount of tokens or ether to reach the tokensForSale)
* get the limit of tokens what a buyer can buy : maxTokenCap 
/ default maxTokenCap = basicRate * maxContribution
/ the Admin can set maxToeknCap by use `setMaxTokenCap()`, 0 - tokensForsale
* suspend and resume function to pause the purchasing. Only Admin can call `suspend()` or `resume()` 










