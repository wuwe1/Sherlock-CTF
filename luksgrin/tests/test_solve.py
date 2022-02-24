def test_solve(a, Setup, HauntedDungeon, Fighter):
    s = Setup.deploy({"from": a[0], "value": 9e18})
    ins = HauntedDungeon.at(s.instance())
    Fighter.deploy(ins, {"from": a[0], "value": 10e18})
    assert s.isSolved()
