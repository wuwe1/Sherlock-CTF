def main(a, Setup, Combination):
    for v in range(1, 8):
        for d in [True, False]:

            s = Setup.deploy({"from": a[0]})
            i = Combination.at(s.combination())
            i.dial(v, d, {"from": a[0]})
            if i.cool():
                print(v, d)
                break

    # i.unlock(75, {"from": a[0], "gas_limit": 120000})
    # assert s.isSolved()
