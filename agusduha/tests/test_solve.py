def test_solve(a, Setup, Solve, KingVault, Boom, Proposer, GovernanceTimelock):
    s = Setup.deploy({"from": a[0], "value": 0.2e18})
    ins = KingVault.at(s.instance())
    gov = GovernanceTimelock.at(ins.owner())
    boom = Boom.deploy({"from": a[0]})
    proposer = Proposer.deploy(gov, ins, boom, {"from": a[0]})
    Solve.deploy(gov, ins, proposer, boom, {"from": a[0]})
    assert s.isSolved()
