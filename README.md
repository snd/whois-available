# whois-available

[![Build Status](https://travis-ci.org/snd/whois-available.png)](https://travis-ci.org/snd/whois-available)

whois-available returns whois information and checks whether domains are available for registration.

### install

```
npm install whois-available
```

### use

```coffeescript
whoisAvailable = require 'whois-available'

whoisAvailable 'google.com', (err, whoisResponse, isAvailable) ->
    # ...
```

### working top level domains

### license: MIT
