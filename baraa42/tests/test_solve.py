def test_solve(a, Setup, Casino, Boom):
    s = Setup.deploy({"from": a[0]})
    i = Casino.at(s.casino())
    Boom.deploy(i, {"from": a[0], "value": 1})

    assert s.isSolved()
