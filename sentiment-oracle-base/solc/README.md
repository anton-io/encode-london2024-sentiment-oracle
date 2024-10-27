# SOLC Compiler

This docker image contains all the dependencies needed to compile a solidity contract. 

# Usage

The following command will share the local folder internally, that contains the contract to be compiled, and produce the abi and bin files.

```
docker run -v <path>/src:/src solc --optimize -o /src/output --abi --bin /src/<path-contract.sol>
```

These files can be used to deploy the contract into the desired EVM compatible chain.

