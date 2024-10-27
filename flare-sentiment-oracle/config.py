#!/usr/bin/env python3

# Shared configuration.

import os
import eth_account
from web3 import Web3

DIR_THIS = os.path.abspath(os.path.dirname(__file__))

# Chain RPC - Using Flares Coston 2.
RPC_URL = 'https://coston2-api.flare.network/ext/C/rpc'
web3 = Web3(Web3.HTTPProvider(RPC_URL))

# Contract's ABI and BIN.
CONTRACT_BIN  = f"{DIR_THIS}/src/output/NewsSentimentOracle.bin"
CONTRACT_ABI  = f"{DIR_THIS}/src/output/NewsSentimentOracle.abi"

# Contract's address after it has been deployed:
CONTRACT_ADDR = f"0x72aCf8dB0e17D5A4bA9eB8176375D8F06eE3bfd0"

# Load private key.
try:
    PKEY = open(f"{DIR_THIS}/.pkey").read()
except Exception as _:
    print(f"Add private key to {DIR_THIS}/.pkey")
    exit(-1)

# Wallet address derived from the private key.
account = eth_account.Account.from_key(PKEY)
user_address = account.address

# Contract's ABI.
contract_abi = open(CONTRACT_ABI, 'r').read()

# Initialize the contract.
contract = web3.eth.contract(address=CONTRACT_ADDR, abi=contract_abi)


