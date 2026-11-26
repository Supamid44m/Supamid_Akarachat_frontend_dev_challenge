### RES-101 · Search shows results for the wrong query

``` 
root cause: many request at at time
fix: I fix by waiting user finish seach which took a few milliseconds then fetch api, First I use "Future.delayed()" it not working 
then I ask AI and suggest me use Timer instead  becuase can cencel when has new onChange method function call and  AI Told me this method I use to solve call "debounce" is method to reduce api call
```

### RES-102 · Crash after leaving My orders

```
root cause: Timer.periodic still running when leave page
fix: store the Timer in a field (timer = Timer.periodic(...)) and call timer?.cancel() in dispose(), so the timer stops when the widget is removed.

I concern about if  has many order items and use pickup_countdowns it make me app slow? becuase use same widget to create many timer



```

### RES-103 · Requests pile up the longer you browse
```
root cause: worker ever(cartService.itemCount, (_) => _recheckAvailability()); still working  and never destroy   
fix: store the work in a field like RES-102 and when onclose dispose it , Ok I remember trip whatever init in initState should be destroy when onClose()
```


### RES-106 · Wrong pickup times; "Pickup today" filter misses deals
```
root cause: Date and time not parse to local time and filter isToday wrong compare with UTC time and today local time
fix: parse start and end pickup date to local use function toLocal()  and in logic is today compare with month and year
```


### AI Log

- Chat GPT
- Claude Code

21/11/2026
* ask about what is  GetxController and compare with React or Nextjs AI told me it like zustand becuase it's state Management and dependecy injection

* ask about issue RES-102 what happened AI told me becuase timer still running when leave page  that make thing it like JavaScript SetInterval or setTimeOut I need to clear it when finish task or when leave page and AI give me trip whatever init in initState should be destroy when onClose()


22/11/2026
* use AI report about todo task remaining for F-1 · Live flash-sale countdowns and how improve performance 

* vibe code use AI add logic about when flash deal expire remove from cart  


23/11/2026
* ask Cluade about RES-106 what todo remaining and AI suggest me logic is today in model should compare with months and year is edge case when utc day not equals local day

26/11/2026
* vibe code: use AI to improve flash deal countdown performance. Instead of each item creating its own Timer.periodic, all FlashDealLive widgets now share one timer (FlashTicker).
  result: one periodic timer for all flash deal countdowns instead of one per item. It stops when no countdown is mounted, and only the countdown Text rebuilds each second.
