def test_solve(a, Setup, Monopoly, Solve):
    s = Setup.deploy({"from": a[0], "value": 1e18})
    ins = Monopoly.at(s.instance())
    dep = a.add(
        private_key="0xe82bf587a88c4a11581ba8b82da3dafa4d3d8488a6f0d7d7ff1640bfcce9b7fb"
    )
    a[0].transfer(dep, 0.35e18)
    Solve.deploy(ins, {"from": dep, "value": 0.25e18})
