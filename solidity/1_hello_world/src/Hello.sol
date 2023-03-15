// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// --------------------------------------------------
// Remix IDE でコンパイルする場合はgithub.comからのimport行をコメント解除して使用してください。
// また、その際はローカルからのimport行をコメントアウトしておいてください。
// --------------------------------------------------
//import "github.com/Arachnid/solidity-stringutils/src/strings.sol";
import "./lib/solidity-stringutils/src/strings.sol";

contract Hello {
    using strings for *;

    string public name = 'Solidity';

    function setName(string memory newName) public {
        name = newName;
    }

    function sayHello() public view returns (string memory) {
        string memory ret = "Hello ".toSlice().concat(name.toSlice());
        return ret.toSlice().concat("!".toSlice());
    }
}
