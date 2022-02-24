def test_solve(a, Setup, BitMania, Solve):
    s = Setup.deploy({"from": a[0]})
    ins = BitMania.at(s.instance())
    Solve.deploy(ins, {"from": a[0]})
    assert s.isSolved()
