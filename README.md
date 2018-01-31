# MOO-Tokensale

Opening time:
 
    presale startTime =  1516896000;
        // 1516896000 converts to Friday January 26, 2018 00:00:00 (am) in time zone Asia/Singapore (+08)
    presale endTime = 1519358400;
        // 1519358400 converts to Friday February 23, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08
    publicsale startTime = 1519876800;
        // 1519876800 converts to Thursday March 01, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08)
    publicsale endTime = 1522468800; 
        // 1522468800 converts to Saturday March 31, 2018 12:00:00 (pm) in time zone Asia/Singapore (+08)

## Presale and Public Sale (fallback function)

* min purchase depends on the date( presale or public sale)
* max purchase depends on the date( presale or public sale)
* pre-authorised

## Private Sale (placeTokens)

* by Admin user
* tokens minted on demand before or while sale is active.
* uses `placeTokens()` function

## Authorisation

* by Admin user or cs user 
* can approve or block

## changable Rate 

* only if it neccessary
* by Admin user
* take care the rate set the bonus: only without reminder!

## Finishing the sale (owner) - passes control of token back to the owner

* call finishSale 

## Starting Trading

* call startTrading on the TOKEN



