# 🚀 ICP Bootcamp - Advanced Backend

Welcome to the **Internet Computer Protocol (ICP) Bootcamp - Advanced Backend**! This repository is designed to help you build advanced backend solutions on ICP using **Motoko**.

## 📜 Table of Contents

- [🎯 Advanced Challenges](#-advanced-challenges)
- [💡 Freedom to Innovate](#-freedom-to-innovate)
- [📖 Learning Outcomes](#-learning-outcomes)
- [🔗 Resources & Documentation](#-resources--documentation)
- [📩 Submit Your Project!](#-submit-your-project)

---

## 🎯 Advanced Challenges

### ✅ **Challenge 1: Build an Authenticated Backend Using Internet Identity**

- How to use Internet Identity on Candid UI
- Restrict canister actions based on **authenticated users**
- Store and manage **user admins**

### ✅ **Challenge 2: Use HTTP Outcalls to Fetch an API and Store Data in a Canister**

- Call an **external API** using HTTP Outcalls
- Implement JSON parsing and a sorting algorithm
- Store the API response in the **canister** and associated with the user.

### ✅ **Challenge 3: Implement Inter-Canister Communication** (WIP)

- Deploy two separate **canisters**
- Implement **data exchange** between them
- Optimize for **performance & efficiency**

### ✅ **Challenge 4: Set Up a CICD Pipeline for Automated Testing & Deployment** (WIP)

- Configure **GitHub Actions** for automated deployment
- Run **unit tests** before deploying
- Automate **canister upgrades & monitoring**

---

## 💡 Freedom to Innovate

Unlike the beginner challenge, the Advanced Backend Challenge gives you more freedom on what you want to implement. You're encouraged to explore, innovate, and build unique backend solutions on ICP.

### Project Idea:

Create a small backend project that showcases unique features from ICP canisters. For example, you can:

- **Generate a Random Number**:
  Create a function that calls a function from the management canister to generate a random number.

- **Search for a Proposal**:
  Create another function that performs an HTTP outcall to the ICP API to search for a proposal number. Then, use a transform method to return the status and body of the response.

- **Automate with Timers**:
  Use the Timer datatype to call these two functions every 30 seconds.

This project idea leverages inter-canister communication, HTTP outcalls, and timers. They are unique capabilities of ICP that empower you to build truly decentralized backend applications.

### 📝 Example Template Code

The code provided in this repository is just an example template to help you get started. Feel free to modify, extend, or completely re-imagine it as you work on your advanced backend challenge. Use it as a reference while exploring the advanced features of ICP.

### 💡 Do Your Own Research:

Explore the links provided in this challenge to dive deeper into each topic. You can also see how we implemented the Internet Identity canister in the frontend of the beginner challenge for inspiration.

---

## 📖 Learning Outcomes

### 🌍 **HTTP Outcalls (Fetching External API Data)**

- Understanding **HTTP outcalls** on ICP
- How to request external data from an API
- Storing API responses in a **canister**

### 🔗 **Inter-Canister Communication**

- Calling another **canister within your project**
- Passing and retrieving **data between canisters**
- Best practices for **handling cross-canister calls**

### 🔧 **Advanced Inter-Canister Communication**

- Calling **Management Canisters**
- Working with **System Canisters**

### ⏳ **Implementing Timers**

- How to use **Timers** for automated tasks
- Best practices for scheduling **recurring actions**

### 🛠️ **Implementing Tests (PicJS)**

- Writing **unit tests** for your canisters
- Using **[PicJS](https://github.com/hadronous/pic-js)** for end-to-end testing
- Debugging & improving **test coverage**

### 📊 **Introduction to Monitoring (CycleOps)**

- Setting up **[CycleOps](https://cycleops.dev/)** for automatic **cycle top-ups**
- Configuring **alerts** for cycle depletion
- Implementing **email notifications** for system health

### 📈 **Canister Logs & Stats**

- Checking **canister status**

```sh
dfx canister status <your_canister>
```

- Viewing **logs**

```sh
dfx canister logs <your_canister>
```

- Monitoring **performance & memory usage**

### 🏆 **Developer Best Practices**

- Managing **state, upgrade, backup & restoration**  
  📚 [Best Practices](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/best-practices/general/#recommendation-state-backup-and-restoration)
- Ensuring **seamless upgrades** without data loss
- Implementing **backup strategies** for canisters

### 🔄 **Implementing CICD for Backend Canister Deployments**

- Automating **build & deployment** with GitHub Actions
- Setting up **continuous integration (CI)**
- Running **automated tests before deployment**

### 🏭 **Introduction to Canister Factories**

- What are **canister factories**?
- When to use **factory patterns** in ICP
- Example: **Dynamic creation of canisters**

---

## 🎯 Advanced Challenges

Please choose 3 out of 5 that interest you most.

### ✅ **Challenge 1: Build an Authenticated Backend Using Internet Identity**

- How to use Internet Identity on Candid UI
- Restrict canister actions based on **authenticated users**
- Store and manage **user admins**

### ✅ **Challenge 2: Use HTTP Outcalls to fetch an API result**

- Call an **external API** using HTTP Outcalls
- Implement JSON parsing
- Return API response

### ✅ **Challenge 3: Implement Inter-Canister Communication**

- Deploy two separate **canisters**
- Do several calls between them, especially **composable queries**
- Call a canister **outside your project** (but still inside localhost)
- Call **Management Canister**

### ✅ **Challenge 4: Implement Timers**

- create a "job" method (meant to be called by the Timer);
- create a **"cron"** job that runs "every 1h".
- create a **"queued"** job that you set to run in "1 min".

### ✅ **Challenge 5: Set Up a CICD Pipeline (with Testing and Linting) and Monitoring**

- Add **tests** to your repo (suggest Mops Test with PocketIC as param)
- Run tests, format lint and audits on **github workflow (Action)**
- Deploy on mainnet (ask Tiago for Faucet Coupon) and:
  - Implement monitoring with CycleOps
  - Cause a trap and then see it in the logs (and also query stats)

---

## 🔗 Resources & Documentation

📚 [Official ICP Docs](https://internetcomputer.org/docs)  
📚 [Motoko Programming Guide](https://sdk.dfinity.org/docs/language-guide/motoko.html)  
📚 [ICP Ninja](https://icp.ninja/)  
📚 [ICP Best Practices](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/best-practices/general/)  
📚 [CycleOps Monitoring](https://cycleops.dev/)

---

## 📩 Submit Your Project!

🎯 **Completed your challenge? Submit your project here:**  
📢 [Submission Form](https://docs.google.com/forms/d/e/1FAIpQLSfRDeUw9sckd9vVmfb9gQKs4btvZRlHLTNBTgN57HdxEnge2w/viewform?usp=dialog)

📌 **Want to explore more challenges? Return to the index:**  
🔗 [ICP Bootcamp Index](https://github.com/pt-icp-hub/ICP-Bootcamp-Index?tab=readme-ov-file)

---

🚀 **Happy Coding & Welcome to Advanced Backend Development on the Internet Computer!** 🚀
