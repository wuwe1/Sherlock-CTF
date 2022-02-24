//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

/**
 *  A simple implementation of combination lock that contains a number dial and key,
 *  Send the correct combination using dial and enter the key to unlock
 *  Use dial function to turn the dial clockwise or anticlockwise
 *  Use any combination of rotation and direction
 */

contract Combination {
    bool public unlocked;

    uint8 public leverPos;

    uint8 public cam3Val;
    uint8 public cam2Val;
    uint8 public cam1Val;

    uint8 public cam3Tab;
    uint8 public cam2Tab;
    uint8 public cam1Tab;

    uint8 public pins;

    mapping(uint8 => uint8) log2;

    /**
     * @param _leverPos Target position of the slots
     * @param _val1 Initial position of tab1
     * @param _val2 Initial position of tab2
     * @param _val3 Initial position of tab3
     * @param _pins Pin value of the key lock
     */
    constructor(
        uint8 _leverPos,
        uint8 _val1,
        uint8 _val2,
        uint8 _val3,
        uint8 _pins
    ) {
        // 32, 2, 8, 2, 180
        leverPos = _leverPos; // 32
        cam1Tab = _val1; // 2 -> cam1Val 64
        cam2Tab = _val2; // 8 -> cam2Val 16
        cam3Tab = _val3; // 2 -> cam3Val 64

        pins = _pins;

        setCamValues();

        log2[128] = 7;
        log2[64] = 6;
        log2[32] = 5;
        log2[16] = 4;
        log2[8] = 3;
        log2[4] = 2;
        log2[2] = 1;
        log2[1] = 0;
    }

    /**
     * @dev Set notch values from tab position
     */
    function setCamValues() internal {
        cam1Val = rotateLeft(cam1Tab, 5); // 1 3 5 7
        cam2Val = rotateLeft(cam2Tab, 3); // 4 5 6 7
        cam3Val = rotateLeft(cam3Tab, 5); // 1 3 5 7
    }

    /**
     * @dev Function to perform left rotation
     */
    function rotateLeft(uint8 _val, uint8 _count) public pure returns (uint8) {
        return (_val >> (8 - _count)) | (_val << _count);
    }

    /**
     * @dev Function to perform right rotation
     */
    function rotateRight(uint8 _val, uint8 _count) public pure returns (uint8) {
        return (_val << (8 - _count)) | (_val >> _count);
    }

    function cam3(uint8 _rotateVal, bool _direction) internal {
        if (_direction) {
            cam3Tab = rotateRight(cam3Tab, _rotateVal);
        } else {
            cam3Tab = rotateLeft(cam3Tab, _rotateVal);
        }
    }

    event gap1(uint8);
    event gap2(uint8);
    event rotate2(uint8);

    function cam2(uint8 _rotateVal, bool _direction) internal {
        // 1-7, True
        // 1 or 2, True
        uint8 gap = 0;
        uint8 _cam2Tab = cam2Tab;
        uint8 _cam3Tab = cam3Tab;
        emit rotate2(_rotateVal);

        if (_direction) {
            gap = _cam2Tab > _cam3Tab
                ? log2[_cam2Tab] - log2[_cam3Tab] - 1
                : 8 - log2[_cam3Tab] + log2[_cam2Tab] - 1;
            // 5
            // 128, 1 -> 6
            // 64, 1 -> 5
            // 2, 1 ->

            cam2Tab = rotateRight(_cam2Tab, _rotateVal);
        } else {
            gap = _cam2Tab > _cam3Tab
                ? (8 - log2[_cam2Tab] + log2[_cam3Tab]) - 1
                : (log2[_cam3Tab] - log2[_cam2Tab]) - 1;

            cam2Tab = rotateLeft(_cam2Tab, _rotateVal);
        }

        emit gap2(gap);
        if (gap < _rotateVal) {
            cam3(_rotateVal - gap, _direction);
        }
    }

    function cam1(uint8 _rotateVal, bool _direction) internal {
        uint8 gap = 0;
        uint8 _cam1Tab = cam1Tab;
        uint8 _cam2Tab = cam2Tab;

        if (_direction) {
            gap = _cam1Tab > _cam2Tab
                ? log2[_cam1Tab] - log2[_cam2Tab] - 1
                : 8 - log2[_cam2Tab] + log2[_cam1Tab] - 1;
            // 2, 8 -> 5
            // 64, 128 -> 6
            // 128, 64 -> 0
            // 8, 4 -> 0

            cam1Tab = rotateRight(_cam1Tab, _rotateVal);
        } else {
            gap = _cam1Tab > _cam2Tab
                ? 8 - log2[_cam1Tab] + log2[_cam2Tab] - 1
                : log2[_cam2Tab] - log2[_cam1Tab] - 1;
            // 4, 2 -> 6
            // 8, 4 -> 6

            cam1Tab = rotateLeft(_cam1Tab, _rotateVal);
        }

        emit gap1(gap);

        if (gap < _rotateVal) {
            cam2(_rotateVal - gap, _direction);
        }
    }

    /**
     * @dev Main function
     * @param _rotateVal - Number of rotation to perform
     * @param _direction - Direction of rotation ( right => true, left => false)
     */
    function dial(uint8 _rotateVal, bool _direction) public {
        require(
            _rotateVal > 0 && _rotateVal < 8,
            "Rotate values out of bounds"
        );

        cam1(_rotateVal, _direction);

        setCamValues();
    }

    /**
     * @dev Function to unlock and lock, enter key to unlock
     * @param _key Key value
     */
    function unlock(uint8 _key) public {
        unlocked =
            ((cam1Val & cam2Val & cam3Val) == leverPos) &&
            (pins ^ _key == type(uint8).max);

        // Simple reset
        dial(7, false);
        dial(7, true);
        dial(3, false);
    }
}
