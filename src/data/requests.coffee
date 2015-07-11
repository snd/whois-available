# this is a mapping from whois server names to
# functions that take the domain and 

module.exports =
  'whois.denic.de': (domain) -> '-T dn,ace ' + domain
