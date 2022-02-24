def rotateLeft(v, c):
    return (v >> (8 - c) | (v << c)) & 255


def rotateRight(v, c):
    return (v << (8 - c) | (v >> c)) & 255


def check(r, v):
    for i in range(1, 9):
        print(i, r(v, i) & 0b11111111)


# >>> for i in range(8):
# ...   print(i, rotateLeft(i, 3), bin(rotateLeft(i,3)))
# ...
# 0 0 0b0
# 1 8 0b1000
# 2 16 0b10000
# 3 24 0b11000
# 4 32 0b100000
# 5 40 0b101000
# 6 48 0b110000
# 7 56 0b111000
# >>> for i in range(8):
# ...   print(i, rotateLeft(i, 5), bin(rotateLeft(i,5)))
# ...
# 0 0 0b0
# 1 32 0b100000
# 2 64 0b1000000
# 3 96 0b1100000
# 4 128 0b10000000
# 5 160 0b10100000
# 6 192 0b11000000
# 7 224 0b11100000


def test_solve(a, Setup, Combination):
    s = Setup.deploy({"from": a[0]})
    i = Combination.at(s.combination())
    # right True
    # left False
    # when cam1Tab = 2, (1,True), (7, False)

    i.dial(7, False, {"from": a[0]})
    i.dial(7, False, {"from": a[0]})
    i.dial(7, False, {"from": a[0]})
    # >>> val(i)
    # 1 8
    # 2 4
    # 3 32
    # >>> tab(i)
    # 1 64
    # 2 128
    # 3 1
    i.dial(7, True, {"from": a[0]})
    # val
    # 1 16
    # 2 2
    # 3 32
    # tab
    # 1 128
    # 2 64
    # 3 1
    i.dial(4, True, {"from": a[0]})
    i.dial(5, False, {"from": a[0]})

    i.unlock(75, {"from": a[0], "gas_limit": 120000})
    assert s.isSolved()

    # log2[128] = 7;
    # log2[64] = 6;
    # log2[32] = 5;
    # log2[16] = 4;
    # log2[8] = 3;
    # log2[4] = 2;
    # log2[2] = 1;
    # log2[1] = 0;


def rotateLeft(v, c):
    return (v >> (8 - c) | (v << c)) & 255


def rotateRight(v, c):
    return (v << (8 - c) | (v >> c)) & 255


def p(i):
    print("val")
    val(i)
    print("tab")
    tab(i)


def val(i):
    print(1, i.cam1Val())
    print(2, i.cam2Val())
    print(3, i.cam3Val())


def tab(i):
    print(1, i.cam1Tab())
    print(2, i.cam2Tab())
    print(3, i.cam3Tab())
