from brownie import network, accounts, MockV3Aggregator, config
import os

FORKED_LOCAL_ENVIOREMENT = ["mainnet-fork", "mainnet-fork-devops"]
LOCAL_BLOCKCHAIN_ENVIORNMENT = ['development', 'ganach-local']

DECIMALS = 8
STARTING_PRICE = 200000000000


def get_account():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIORNMENT or network.show_active() in FORKED_LOCAL_ENVIOREMENT:
        account = accounts[0]
        return account
    else:
        account = accounts.add(os.getenv("PRIVATE_KEY"))
        return account


def deploy_mocks():
    account = get_account()
    print(f"The network is {network.show_active()}")
    print("Deploying Mocks...")
    if len(MockV3Aggregator) <= 0:
        MockV3Aggregator.deploy(
            DECIMALS, STARTING_PRICE, {'from': account})
    print('Mocks Deployed')
