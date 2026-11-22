### RES-101 · Search shows results for the wrong query

``` root cuase : many request at at time
I fix by waiting user finish seach which took a few milliseconds then fetch api, First I use "Future.delayed()" it not working 
then I ask AI and suggest me use Timer instead  becuase can cencel when has new onChange method function call and  AI Told me this method I use to solve call "debounce" is method to reduce api call
```
