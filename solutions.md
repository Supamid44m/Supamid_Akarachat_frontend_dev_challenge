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
```

### RES-103 · Requests pile up the longer you browse
```
root cause: worker ever(cartService.itemCount, (_) => _recheckAvailability()); still working  and never destroy   
fix: store the work in a field like RES-102 and when onclose dispose it , Ok I remember trip whatever init in initState should be destroy when onClose()
```




### AI Log

21/11/2026

* ask about what is  GetxController and compare with React or Nextjs AI told me it like zustand becuase it's state Management and dependecy injection

* ask about issue RES-102 what happened AI told me becuase timer still running when leave page  that make thing it like JavaScript SetInterval or setTimeOut I need to clear it when finish task or when leave page and AI give me trip whatever init in initState should be destroy when onClose()


22/11/2026
* use AI report about todo task remaining for F-1 · Live flash-sale countdowns and how improve performance 

