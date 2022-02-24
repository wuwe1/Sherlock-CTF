def test_solve(a, Setup, StableSwap2, Solve):
    s = Setup.deploy({"from": a[0], "value": 0.0000374e18})
    ins = StableSwap2.at(s.instance())
    Solve.deploy(s, ins, {"from": a[0]})
    assert s.isSolved()
