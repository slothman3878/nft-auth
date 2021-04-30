# NFT authentication token
### for designing a <i>Serverless</i> authentication backend

The idea behind it is simple:
* When users "register" with an application, they are given an NFT which can later be used as proof of registration.
* NFTs instead of generic fungible tokens since NFTs can store user meta-data (instead of asset URI)
* The application authenticates the user (or in this case, the user's ethereum account) by checking token ownership.