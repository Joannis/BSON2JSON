# BSON2JSON

[![Build Status](https://travis-ci.org/czechboy0/BSON2JSON.svg?branch=master)](https://travis-ci.org/czechboy0/BSON2JSON)
![Platforms](https://img.shields.io/badge/platforms-Linux%20%7C%20OS%20X-blue.svg)
![Package Managers](https://img.shields.io/badge/package%20managers-SwiftPM-yellow.svg)

[![Blog](https://img.shields.io/badge/blog-honzadvorsky.com-green.svg)](http://honzadvorsky.com)
[![Twitter Czechboy0](https://img.shields.io/badge/twitter-czechboy0-green.svg)](http://twitter.com/czechboy0)

> Swift conversions between PlanTeam.BSON and C7.JSON

Simple two extensions to convert between BSON and JSON, based on [MongoDB's description](https://docs.mongodb.com/v3.0/reference/mongodb-extended-json/).

```swift
let myJSON = myBSON.toJSON()
```

```swift
let myBSON = myJSON.toBSON()
```

:gift_heart: Contributing
------------
Please create an issue with a description of your problem or open a pull request with a fix.

:v: License
-------
MIT

:alien: Author
------
Honza Dvorsky - http://honzadvorsky.com, [@czechboy0](http://twitter.com/czechboy0)
