const HDWalletProvider = require("truffle-hdwallet-provider-klaytn");
const NETWORK_ID = '1001' //baobab 고유 network id
const GASLIMIT = '200000000' //배포 시 필요한 gas 한도
const URL = `https://api.baobab.klaytn.net:8651`  //baobab testnet
const PRIVATE_KEY = '0xa42c3e961699cfd3c02d5a68dadff9840f72b70099fd0f456c59be34f3fe7efd' //company18!

module.exports = {
  networks: {  
    ganache: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id 
    },

    baobab: {
      provider: new HDWalletProvider(PRIVATE_KEY, URL), 
      //클레이튼 노드를 제공하는 공급자 명시
      //내 private_key로 baobab에 연결
      network_id: NETWORK_ID,
      gas: GASLIMIT,
      gasPrice: null, //baobab에서 알아서 gasPrice 잡아주도록
    }  
  }
}
