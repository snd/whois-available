# whois-available

*1.0.0 introduced a breaking change. see the [changelog](#changelog).*

[![NPM Package](https://img.shields.io/npm/v/whois-available.svg?style=flat)](https://www.npmjs.org/package/whois-available)
[![Build Status](https://travis-ci.org/snd/whois-available.svg?branch=master)](https://travis-ci.org/snd/whois-available/branches)
[![Dependencies](https://david-dm.org/snd/whois-available.svg)](https://david-dm.org/snd/whois-available)

<!--
TODO
domain is not supported error message

make sure that you are using the strongest most authoritative whois servers for each domain
-->

**check domain availability and fetch [whois information](https://en.wikipedia.org/wiki/WHOIS) in a single request**

each TLD (toplevel domain) has its own whois server.  
each whois server has a different way of saying whether domains are available or taken.  
**whois-available normalizes those differences for [over 180 common TLDs](src/servers.coffee) so you don't have to !**

three steps

1. list of all whois servers from iana

features

high quality, integration tests, 180 supported domains

tested to work on XXX domains.

you can programmatically get an up to date list of supported domains.

```
npm install whois-available
```

```javascript
var whois = require('whois-available');

whois('google.com', function(err, result) {
  console.log('is domain available:', result.isAvailable);
  console.log('full whois response:', result.response);
});
```

all result properties:

- `isAvailable` whether the domain is available
- `response` the full whois response returned by the whois server
- `request` the raw request send to the whois server
- `domain` the domain in question
- `punycode` [punycode](https://en.wikipedia.org/wiki/Punycode) of the domain in question
- `tld` the toplevel domain in question
- `server` the whois server responsible for the tld
- `predicate` used to interpret whether the response means that the domain is available

whois-available has a traditional Node.js callback interface
as not to force the user to use
[promises](https://github.com/petkaantonov/bluebird).
[promises](https://github.com/petkaantonov/bluebird)
make async code more managable and less complex than callbacks.
you should probably use them.
here's the same example with promises:

```javascript
var Promise = require('bluebird');
var whois = Promise.promisify(require('whois-available'));

whois('google.com').then(function(result) {
  console.log('is domain available:', result.isAvailable);
  console.log('full whois response:', result.response);
});
```

### working top level domains

see the [keys in this file](src/servers.coffee) for a list of all working toplevel domains.


### how whois-available works 

if you want to add support for another toplevel domain

### contribution

```
script/generate-whois-servers-coffee > src/data/whois-servers-generated.coffee
```

```
script/generate-tlds-txt > tlds.txt
```

### API

the following API documentation uses
[flow type annotations](http://flowtype.org/) so you know precisely
how to use it.

#### whoisAvailable

`
type Result = {
  isAvailable: boolean,
  domain: string
};
`

`whois(domain: string, cb: (?err: , ?result: Result) => any): any`

`whois.tlds :: `

`whois.tlds`


### under the hood

### changelog

#### 1.0

instead of previously:

```javascript
whois('google.com', function(err, isAvailable, response) {
  console.log(isAvailable);
  console.log(response);
});
```

now do:

```javascript
whois('google.com', function(err, result) {
  console.log(result.isAvailable);
  console.log(result.response);
});
```

## [license: MIT](LICENSE)
