# Difference between etherscanApi & Provider.getLogs()

1. ## etherscan api

   - request Get method

   ```apl
   https://api-sepolia.etherscan.io/api?module=logs
   &action=getLogs
   &fromBlock=4137553  // from block number
   &toBlock=latest  // 'latest' block number
   &address=0x09547e68ce13fdecb5bf52fd17379fffa97cb797 // 'Address'
   &topic0=0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef // 'Event hex'
   &topic0_2_opr=and  // 'and' or 'or'
   &topic2=0x0000000000000000000000006A42527918fD57911f442761a1C4157A1c059ae3
   &apikey=QR86PVCJ3ZPSM9BYHCPWX85T84Y3EWRMIQ // 'Your api key'
   ```

   - response

   ```json
   {
       "status": "1",
       "message": "OK",
       "result": [
           {
               "address": "0x09547e68ce13fdecb5bf52fd17379fffa97cb797",
               "topics": [
                   "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
                   "0x0000000000000000000000000000000000000000000000000000000000000000",
                   "0x0000000000000000000000006a42527918fd57911f442761a1c4157a1c059ae3",
                   "0x000000000000000000000000000000000000000000000000000000000007afc8"
               ],
               "data": "0x",
               "blockNumber": "0x43e0a7",
               "blockHash": "0xad9f8886cba958cc47c5cb6a5810f6d96b0b4569bd2a7e03192d6b68ff5e5a05",
               "timeStamp": "0x65224f08",
               "gasPrice": "0x9502f978",
               "gasUsed": "0x71e96",
               "logIndex": "0x27",
               "transactionHash": "0x7051ee0ff26f60438127442eb597f47c50ae42b2afde5a3499cb3d939fb667ce",
               "transactionIndex": "0x13"
           },
           {
               "address": "0x09547e68ce13fdecb5bf52fd17379fffa97cb797",
               "topics": [
                   "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
                   "0x0000000000000000000000000000000000000000000000000000000000000000",
                   "0x0000000000000000000000006a42527918fd57911f442761a1c4157a1c059ae3",
                   "0x000000000000000000000000000000000000000000000000000000000007b013"
               ],
               "data": "0x",
               "blockNumber": "0x43e0af",
               "blockHash": "0xcd749dc893061542e2bf45eab10f42900ad82a971622ee4ec18800f02e49b5cf",
               "timeStamp": "0x65224f68",
               "gasPrice": "0x9502f967",
               "gasUsed": "0x7319c",
               "logIndex": "0x1b",
               "transactionHash": "0xa6047ba435760998bf562d9bbe574682f4391e23d12b1f317f754c8be81e9219",
               "transactionIndex": "0x8"
           },
       ]
   }
   ```

2. ## Provider.getLogs() method  (ethers.js version 6)

   - filter (sample)

     ```js
     const inputfilter = {
           address: '0x09547e68ce13fdecb5bf52fd17379fffa97cb797',
           topics: [
               '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
               null,
               ethers.zeroPadValue(_address,32),
               null
           ],
           fromBlock: 4137553,
           toBlock: 'latest'
         };
     ```

   - response (single object for sample)

     ```json
     {
       blockNumber: 4638586,
       blockHash: '0x2b0a16021671020fabbeebc88de601d701a016219a55fa4571337e53a09167ff',
       transactionIndex: 3,
       removed: false,
       address: '0xf96585E17750CeF1ed959846bfEE9983ef96A324',
       data: '0x00000000000000000000000000000000000000000000000038dd4aad0f2f47ab',
       topics: [
         '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
         '0x000000000000000000000000bf0cd55f9a2528c897896e111eff5b89b1e7abad',
         '0x0000000000000000000000000600bec31e22b57b4a52277e7512e9a28954fd9c'
       ],
       transactionHash: '0xe05ff43073b8c6203bfbdd628165efd3bba2e425b36eada692e85a5404312572',
       logIndex: 2
     }
     ```

     

​	
