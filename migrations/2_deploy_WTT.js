const WebToonToken = artifacts.require('./WebToonToken.sol')
const fs = require('fs')

module.exports = function (deployer) {
  var name = "JOY Token";
  var symbol = "JOY";

  //WebToonToken 배포하면 받는 json데이터를 파일에 저장
  deployer.deploy(WebToonToken, name, symbol)
    .then(() => {
      if (WebToonToken._json) {
        fs.writeFile(
          'deployedABI',
          JSON.stringify(WebToonToken._json.abi),
          (err) => {
            if (err) throw err
            console.log("파일에 ABI 입력 성공");
          })
      }

      fs.writeFile(
        'deployedAddress',
        WebToonToken.address,
        (err) => {
          if (err) throw err
          console.log("파일에 주소 입력 성공");
        })
    })
}