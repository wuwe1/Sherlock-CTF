def test_solve(a, Setup, Challenge, GovToken, Solve, ERC1820Registry):
    ERC1820_deployer = a.at("0xa990077c3205cbdf861e17fa532eeb069ce9ff96", force=True)
    ERC1820Registry.deploy({"from": ERC1820_deployer})
    s = Setup.deploy({"from": a[0]})
    ins = Challenge.at(s.instance())
    gov = GovToken.at(ins.govTokens(0))
    sol = Solve.deploy(ins, gov, {"from": a[0]})
    tx = sol.go({"from": a[0]})
    assert s.isSolved()


# keccak(0x0000000000000000000000000000000000000000000000000000000000000000)
# 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563

# keccak(0x0000000000000000000000000000000000000000000000000000000000000003)
# 0xc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b
# keccak(3) - keccak(0)
# 0x99496d3549cdd9582356b31fa6da6b601e1c7cc4f2c4f9da27f5832e607e12f8
00e18
