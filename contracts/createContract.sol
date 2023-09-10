// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Pair{
    address public factory;
    address public tokenA;
    address public tokenB;

    constructor() payable {
        factory = msg.sender;
    }

    function initialize(address token1, address token2) external {
        require(msg.sender == factory);
        tokenA = token1;
        tokenB = token2;
    } 
}

contract Mytoken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name,symbol) {
        
    }
}

contract Factory{
    mapping(address => mapping (address => address)) public getPairAddress;
    address[] public allPairs;

    constructor() payable {}

    /*
    普通创建合约

    Contract contract = new Contract(params); 或 Contract contract = new Contract{value : 1 ether}(params);

    */
    

    // 普通创建ERC20
    function createERC20(string memory name, string memory symbol) external returns(address tokenAddr) {
        // name 或 symbol 不为空
        bytes memory str1 = bytes(abi.encodePacked(name));
        bytes memory str2 = bytes(abi.encodePacked(symbol));
        require(str1.length != 0 && str2.length != 0,  "Invalid name or symbol"); 

        Mytoken mytoken = new Mytoken(name,symbol);

        tokenAddr = address(mytoken);
    }

    // 普通创建token pair
    function createPair(address tokenA,address tokenB) external returns(address pairAddr) {
        require(tokenA != address(0) && tokenB != address(0));
        Pair pair = new Pair(); 
        pairAddr = address(pair);
        pair.initialize(tokenA, tokenB);

        getPairAddress[tokenA][tokenB] = pairAddr;
        getPairAddress[tokenB][tokenA] = pairAddr;

        allPairs.push(pairAddr);
    }

    /*
    create2创建合约方法

    0xFF：一个常数，避免和CREATE冲突
    CreatorAddress: 调用 Create2 的当前合约（创建合约）地址。
    salt（盐）：一个创建者指定的 uint256 类型的值，的主要目的是用来影响新创建的合约的地址。
    initcode: 新合约的初始字节码（合约的Creation Code和构造函数的参数）。
    */

    // create2创建ERC20
    function create2ERC20(string memory name, string memory symbol) external returns(address tokenAddr) {
        // name 或 symbol 不为空
        bytes memory str1 = bytes(abi.encodePacked(name));
        bytes memory str2 = bytes(abi.encodePacked(symbol));
        require(str1.length != 0 && str2.length != 0,  "Invalid name or symbol"); 

        bytes32 salt = keccak256(abi.encodePacked(name,symbol));
        Mytoken mytoken = new Mytoken{salt: salt}(name,symbol);  //或 Mytoken mytoken = new Mytoken{salt: salt, value: 1 ether}(name, symbol);

        tokenAddr = address(mytoken);
    }

    // create2创建token pair
    function createPair2(address tokenA,address tokenB) external returns(address pairAddr) {
        require(tokenA != address(0) && tokenB != address(0));
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); //将tokenA和tokenB按大小排序
        bytes32 salt = keccak256(abi.encodePacked("0xaa"));
        Pair pair = new Pair{salt: salt}(); 
        pairAddr = address(pair);
        pair.initialize(token0, token1);

        getPairAddress[tokenA][tokenB] = pairAddr;
        getPairAddress[tokenB][tokenA] = pairAddr;

        allPairs.push(pairAddr);
    }

    // 提前计算pair合约地址，计算token pair
    function calculateAddr(address tokenA, address tokenB) public view returns(address predictedAddress){
        require(tokenA != tokenB, 'IDENTICAL_ADDRESSES'); //避免tokenA和tokenB相同产生的冲突
        // 计算用tokenA和tokenB地址计算salt
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); //将tokenA和tokenB按大小排序
        // bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        bytes32 salt = keccak256(abi.encode(token0,token1));
        // 计算合约地址方法 hash()
        predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(type(Pair).creationCode)
        )))));
    }

    // 提前计算ERC20合约地址
    function calculateAddr1(string memory name,string memory symbol) public view returns(address predictedAddress){
        // name 或 symbol 不为空
        bytes memory str1 = bytes(abi.encodePacked(name));
        bytes memory str2 = bytes(abi.encodePacked(symbol));
        require(str1.length != 0 && str2.length != 0,  "Invalid name or symbol"); 

        bytes32 salt = keccak256(abi.encodePacked(name,symbol));
        // 计算合约地址方法 hash()
        predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(abi.encodePacked((type(Mytoken).creationCode),abi.encode(name,symbol)))
        )))));
    }
}
