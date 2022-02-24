def test_solve(a, Setup, Solve, BuiltByANoob):
    s = Setup.deploy({"from": a[0]})
    ins = BuiltByANoob.at(s.instance())
    Solve.deploy(ins, {"from": a[0]})
    assert s.isSolved()
