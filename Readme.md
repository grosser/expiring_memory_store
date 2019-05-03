Fast, Simple, & Threadsafe Ruby In-Memory Store with expiration

 - Fast (using Process::CLOCK_MONOTONIC)
 - Simple
 - Threadsafe
 - Can cache nil

Install
=======

```Bash
gem install expiring_memory_store
```

Usage
=====

```Ruby
store = ExpiringMemoryStore.new
store.set :a, 1, expires_in: 4
store.get :a # -> 1
store.get :b # -> nil
store.add :a, 2, expires_in: 4 # -> false
store.fetch(:a) { 1 } # -> 1
store.cleanup # remove all expired entries
```

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/expiring_memory_store.svg)](https://travis-ci.org/grosser/expiring_memory_store)
