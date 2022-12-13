import { ethers } from "./ethers-5.2.esm.min.js";
import { abi, contractAddress } from "./constants.js";
if (typeof window.ethereum == "undefined") {
  {
    document.getElementById("connect").innerHTML =
      "Please install metamask extension...";
  }
}
async function connect() {
  if (typeof window.ethereum !== "undefined") {
    try {
      await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      document.getElementById("connect").innerHTML = "Connected";
    } catch (err) {
      alert(err.message);
    }
  }
}

async function fund(ethAmount) {
  if (typeof window.ethereum !== "undefined") {
    try {
      console.log("Funding with " + ethAmount + " ETH");
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(contractAddress, abi, signer);
      //   console.log(signer);
      const transactionResponse = await contract.fund({
        value: ethers.utils.parseEther(ethAmount),
      });

      await listenForTransactionMine(transactionResponse, provider);
    } catch (err) {
      alert(err.message);
    }
  }
}

function listenForTransactionMine(transactionResponse, provider) {
  console.log(`Mining ${transactionResponse.hash}...`);
  return new Promise((resolve, reject) => {
    provider.once(transactionResponse.hash, transactionReceipt => {
      console.log(
        `Completed with ${transactionReceipt.confirmations} confirmations`
      );
      alert("Mining Successful...");
      resolve();
    });
  });
}
async function withdraw() {
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddress, abi, signer);
    try {
      const transactionResponse = await contract.withdraw();
      await listenForTransactionMine(transactionResponse, provider);
    } catch (err) {
      alert(err.message);
    }
  }
}
async function getBalance() {
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const balance = await provider.getBalance(contractAddress);
    document.getElementById("balance").value =
      ethers.utils.formatEther(balance);
  }
}

const connectBtn = document.getElementById("connect");
const fundBtn = document.getElementById("fund");
const withdrawBtn = document.getElementById("withdraw");

const ethAmount = document.getElementById("ethAmount");
const getBalanceBtn = document.getElementById("getBalance");

connectBtn?.addEventListener("click", e => {
  connect();
});

withdrawBtn?.addEventListener("click", e => {
  withdraw();
});

fundBtn?.addEventListener("click", async e => {
  fundBtn.innerHTML = "Funding in Process...";
  await fund(ethAmount?.value);
  ethAmount.value = "";
  fundBtn.innerHTML = "Fund";
});

getBalanceBtn?.addEventListener("click", e => {
  getBalance();
});
