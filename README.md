# NFT authentication token
### for designing a <i>Serverless</i> authentication backend

The idea behind it is simple:
* When users "register" with an application, they are given an NFT which can later be used as proof of registration.
* NFTs instead of generic fungible tokens since NFTs can store user meta-data (instead of asset URI)
* The application authenticates the user (or in this case, the user's ethereum account) by checking token ownership.

Contains 2 contracts
1. `AbstractUser.sol` is an abstract contract providing a skeleton for concrete implementations.
2. `UserExample.sol` is an example User model implementing `AbstractUser.sol`

## Miscellaneous thoughts
* Including passwords into the implementation, and how to deal with password resets for those users who have forgotten their passwords.
* It occurs to me that passwords aren't strictly necessary. All the frontend has to do is check that the user's wallet is connected, then check token ownership. Essentially, in this case the user is signing in with their wallet private key.
* Consider <a href="https://publications.lib.chalmers.se/records/fulltext/256254/256254.pdf">this paper</a>.

## TODOs
1. Relevent tests
2. Demo frontend