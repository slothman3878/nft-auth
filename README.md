# NFT authentication token
### for designing a <i>Serverless</i> authentication backend

The idea behind it is simple:
* When users "register" with an application, they are given an NFT which can later be used as proof of registration.
* NFTs instead of generic fungible tokens since NFTs can store user meta-data (instead of asset URI)
* The application authenticates the user (or in this case, the user's ethereum account) by checking token ownership.

## Miscellaneous thoughts
* It occurs to me that the User Meta Data doesn't have to be a struct. It can be, in fact, a contract, with mutable data. Something to think about.
* Once authenticated, perhaps the user recieves a session token.
* How to deal with password resets for those users who have forgotten their passwords.

## TODOs
1. non-abstract contract inheriting base NFTSubscriber contract
2. Relevent tests