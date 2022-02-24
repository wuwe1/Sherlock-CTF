def test_solve(a, Factory):
    ins = Factory.deploy({"from": a[0]})
    bytecode = ins.getBytecode()
    for i in range(2**256):
        tx = ins.createContract(bytecode, i, {"from": a[0]})
        address = tx.return_value
        if ins.isForbidden(address):
            assert 0
