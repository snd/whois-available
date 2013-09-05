# whois-available

whois-available returns whois information and checks whether domains are available

### install

```
npm install whois-available
```

### use

```javascript
var whoisAvailable = require('whois-available');

whoisAvailable('google.com', function(err, whoisResponse, isAvailable) {
    // ...
});
```

### working top level domains

ac, ae, aero, af, ag, ai, am, arpa, as, asia, at, au, ax, be, bg, bi, biz, bj, br, by, ca, cat, cc, ch, cl, cn, co, com, coop, cx, cz, de, dk, dm, ec, edu, ee, eu, fi, fo, fr, gd, gg, gi, gl, gov, gs, gy, hk, hn, hr, ht, hu, ie, il, im, in, info, int, io, iq, ir, is, it, je, jobs, jp, ke, kg, ki, kr, kz, la, li, lt, lu, lv, ma, md, me, mo, mobi, ms, mu, museum, mx, my, na, name, nc, net, ng, nl, no, nu, nz, om, org, pe, pl, pm, post, pr, pro, pt, pw, qa, re, ro, rs, ru, sa, sb, se, sg, sh, si, sk, sm, so, st, sx, sy, tc, tel, tf, th, tk, tl, tm, tn, to, tr, travel, tv, tz, ua, ug, uk, us, uy, uz, ve, wf, ws, xn--fiqs8s, xn--fiqz9s, xn--mgbaam7a8h, xn--ygbi2ammx, xxx, yt

### license: MIT
