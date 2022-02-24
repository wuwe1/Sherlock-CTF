def test_solve(a, Setup, CollectReward):
    """
    0 1 2 3 4 5 6 7 8
                ^
    [withdraTime:ONE_DAY:duration] must include 6
    """
    s = Setup.deploy({"from": a[0], "value": 1e18})
    i = CollectReward.at(s.instance())
    i.collect(
        i.programStartTime() + 6 * i.ONE_DAY(),
        {"from": a[0], "value": 1e18, "gas_limit": 120000},
    )
    assert s.isSolved()
