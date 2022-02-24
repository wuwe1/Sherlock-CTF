def test_solve(a, Setup, SwissTreasury, Proposer, Solve):
    s = Setup.deploy({"from": a[0], "value": 1e18})
    i = SwissTreasury.at(s.instance())
    proposer = Proposer.deploy(i, {"from": a[0], "gas_limit": 12000000})
    Solve.deploy(i, proposer, {"from": a[0], "gas_limit": 12000000})
    assert s.isSolved()
