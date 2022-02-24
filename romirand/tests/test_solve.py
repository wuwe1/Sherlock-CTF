def test_solve(a, Unbreakable, Setup, Solve1, Solve2):
    s = Setup.deploy({"from": a[0]})
    i = Unbreakable.at(s.instance())
    s1 = Solve1.deploy(i, {"from": a[0], "gas_limit": 12000000})
    s2 = Solve2.deploy(i, s1, {"from": a[0], "gas_limit": 12000000})
    s2.finalize(i, {"from": a[0], "gas_limit": 12000000})
    assert s.isSolved()
