from brownie import web3


def main():
    address = "0xfd4f30c20da65a37fd74d55b257442a08469e6a6"
    init_code = "0x6080604052348015600f57600080fd5b50603f80601d6000396000f3fe6080604052600080fdfea2646970667358221220a086b15266b2b2e538c6fbc1e527d8e2cd4b97d4b7a2e9e3154fa1535d604f4a64736f6c63430008040033"
    # salt = "0x0000000000000000000000000000000000000000000000000000000003496263"
    for i in range(2**256):
        salt = "0x" + str(i).rjust(64, "0")
        if i % 10000 == 0:
            print(i)

        if create2_address(address, salt, init_code).lower().endswith("f0b1d"):
            print(i)
            print(salt)
            break


def create2_address(address, salt, init_code):
    """Test the CREATE2 opcode Python implementation.

    EIP-104
    https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1014.md
    """

    pre = "0xff"
    b_pre = bytes.fromhex(pre[2:])
    b_address = bytes.fromhex(address[2:])
    b_salt = bytes.fromhex(salt[2:])
    b_init_code = bytes.fromhex(init_code[2:])

    keccak_b_init_code = web3.keccak(b_init_code)
    b_result = web3.keccak(b_pre + b_address + b_salt + keccak_b_init_code)
    result_address = web3.toChecksumAddress(b_result[12:].hex())
    return result_address
