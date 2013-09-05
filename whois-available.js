var whoisAvailable = require('./src/whois-available');

whoisAvailable('test.de', function(err, whoisResponse, isAvailable) {
    if (err) {
        throw err;
    }

    console.log('domain: ', 'test.de');
    console.log('isAvailable: ', isAvailable);
    console.log('whoisResponse: ', whoisResponse);

    whoisAvailable('3e06671903a734da0d0e8f6fff25ffb.de', function(err, whoisResponse, isAvailable) {
        if (err) {
            throw err;
        }

        console.log('domain: ', '3e06671903a734da0d0e8f6fff25ffb.de');
        console.log('isAvailable: ', isAvailable);
        console.log('whoisResponse: ', whoisResponse);
    });
});
