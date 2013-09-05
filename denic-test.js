var common = require('./src/common');

var commandString = '-T dn,ace test.de\r\n';

common.tcpRequest(43, 'whois.denic.de', commandString, function(err, response) {
    console.log(err);
    console.log(response);
});
