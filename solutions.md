### RES-101 · Search shows results for the wrong query

```
root cause: many request at at time
fix: I fix by waiting user finish seach which took a few milliseconds then fetch api, First I use "Future.delayed()" it not working
then I ask AI and suggest me use Timer instead  becuase can cencel when has new onChange method function call and  AI Told me this method I use to solve call "debounce" is method to reduce api call

Rejected: Future.delayed cannot be cancelled when a new keystroke arrives, so old searches still ran. That's why I switched to a cancellable Timer.

Edge case : If i find sushi test when spacebar OnChange function will work and make 
```

### RES-102 · Crash after leaving My orders

```
root cause: Timer.periodic still running when leave page
fix: store the Timer in a field (timer = Timer.periodic(...)) and call timer?.cancel() in dispose(), so the timer stops when the widget is removed.

I concern about if  has many order items and use pickup_countdowns it make me app slow? becuase use same widget to create many timer

Edge cases: many orders mean one timer per item, which could share one ticker like FlashTicker; once the pickup window has started, the widget shows "Pickup window is open".
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

Edge case (overnight window, e.g. 22:00-01:00): this is not described in PROBLEM.md. It is an edge case of RES-106 that I found while checking the AI suggestion. AI suggested that isToday in PickupWindowModel compares year, month and day of start, but it only looks at start.
- At 23:00 on the start day: isToday is true, which is correct.
- At 00:30 the next day, with data loaded before midnight: pickup is still open, but isToday is false, so the "Pickup today" filter hides the deal.
- If data is reloaded at 00:30: the fake backend returns the next window (tonight 22:00), not the one still open. I can't change this because the backend must not be modified.
Not handled yet. Possible fix: isToday => (start is today) || isOpenNow.
```

### AI Log

- Chat GPT
- Claude Code

21/11/2026

- ask about what is GetxController and compare with React or Nextjs AI told me it like zustand becuase it's state Management and dependecy injection

- ask about issue RES-102 what happened AI told me becuase timer still running when leave page that make thing it like JavaScript SetInterval or setTimeOut I need to clear it when finish task or when leave page and AI give me trip whatever init in initState should be destroy when onClose()

22/11/2026

- use AI report about todo task remaining for F-1 · Live flash-sale countdowns and how improve performance

- vibe code use AI add logic about when flash deal expire remove from cart

23/11/2026

- ask Cluade about RES-106 what todo remaining and AI suggest me logic is today in model should compare with months and year is edge case when utc day not equals local day

26/11/2026

- vibe code: use AI to improve flash deal countdown performance. Instead of each item creating its own Timer.periodic, all FlashDealLive widgets now share one timer (FlashTicker).
  result: one periodic timer for all flash deal countdowns instead of one per item. It stops when no countdown is mounted, and only the countdown Text rebuilds each second.

- use AI compiled sentence and grammar


- AI suggestion for PickupWindowModel was incomplete: isToday only compares start with today. I questioned it with an overnight window (22:00-01:00) and found that after midnight a window that is still open is not counted as today.

### Design questions

Q1 In this codebase, what is the difference between a GetxController's lifecycle and a widget State's lifecycle? Name one bug from Part A that exists because of confusion between the two.

```
A GetxController is owned by GetX dependency injection: onInit runs when it is first put or found, and onClose runs when its route or binding is removed. A GetxService like CartService lives for the whole app. A widget State is owned by the element tree: initState/dispose run whenever the widget is mounted or unmounted, which can happen many times (for example list items scrolling in and out).

One bug from Part A caused by this is RES-103. DealDetailsController registered an ever() worker on cartService.itemCount. CartService is a GetxService that lives for the whole app, and the worker was not cancelled automatically when the controller was closed. So every deal page viewed earlier kept re-fetching its deal on each cart change. The fix is to keep the Worker in a field and call dispose() on it in onClose().
```

Q3 How would you write an automated test that would have caught RES-106 before release? What (if anything) would you change in the code to make such a test possible?

```
A unit test on PickupWindowModel.fromJson: given "start": "2026-11-25T23:00:00Z" with the timezone set to Asia/Bangkok (UTC+7), expect label to start with "06:00", and expect isToday to be true when "now" is 26 Nov local time.

```
### Time spent, roughly, and what you would do next with one more day.
```
Time spent: over 4 days (21, 22, 23 and 26 Nov).
Done: RES-101, RES-102, RES-103, RES-106 and F-1.
Not done: RES-104, RES-105, RES-107, F-2 and F-3, Q2.
```

```
With one more day, in this order:
1. Fix the overnight pickup window (RES-106), so a window that is still open after midnight stays in "Pickup today".
2. Write unit tests for RES-106 and F-1 (countdown reaches zero, expired deal is removed from the bag).
3. Profile F-1 in DevTools to check that only the countdown text rebuilds each second.
4. Read more of the codebase, then start RES-107 (deep link crash).

```