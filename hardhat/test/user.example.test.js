const { expect } = require("chai");
const { waffle } = require('hardhat');

let provider = waffle.provider;

describe("AutographDapp contract", function() {
  let A, B;

  let instances = {};

  beforeEach(async function() {
    [A, B] = await ethers.getSigners();
    UserExample = await ethers.getContractFactory('User');

    instances.main = await UserExample.deploy();
    await instances.main.deployed();

    instances.A = await instances.main.connect(A);
    instances.B = await instances.main.connect(B);

    await instances.A.register('A');
    await instances.B.register('B');
  });

  it('Register both A and B as users', async function() {
    expect(await instances.main.name()).to.equal('User Example');

    expect((await instances.main.tokenMeta(1)).username).to.equal('A');
    expect((await instances.main.tokenMeta(2)).username).to.equal('B');
  });

  it('Authentication test', async function() {
    expect(await instances.A.authenticate('A')).to.equal(true);
    expect(await instances.B.authenticate('A')).to.equal(false);
    expect(await instances.A.authenticate('B')).to.equal(false);
    expect(await instances.B.authenticate('B')).to.equal(true);
  });
})