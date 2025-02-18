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

Please choose 3 out of 5 that interest you most.

### ✅ **Challenge 1: Build an Authenticated Backend Using Internet Identity**

- How to use Internet Identity on Candid UI
- Restrict canister actions based on **authenticated users**
- Store and manage **user admins**

#### 💡 Tips
- For you to use Internet Identity on Candid UI, you need to add the url path to it on the ii query param, like "http://127...cai&ii=http://be2us-64aaa-aaaaa-qaabq-cai.localhost:4943/". Where the "be2us...cai" is the canister id of your local Internet Identity.

### ✅ **Challenge 2: Use HTTP Outcalls to fetch an API result**

- Call an **external API** using HTTP Outcalls
- Implement JSON parsing
- Return API response

#### 💡 Tips
- Ask AI to generate an HTTP request example for you
- Check the specific documentation at: 
  - [Intro to HTTP Outcalls](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/advanced-features/https-outcalls/https-outcalls-how-to-use)
  - [Example of GET call](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/advanced-features/https-outcalls/https-outcalls-get)


### ✅ **Challenge 3: Implement Inter-Canister Communication**

- Deploy two separate **canisters** or a bucket canister (see example at composable queries below)
- Do several calls between them, especially **composable queries**
- Call a canister **outside your project** (but still inside localhost)
- Call **Management Canister** to know which principal controls your canister, or how much memory left you still have.

#### 💡 Tips
- https://internetcomputer.org/docs/current/developer-docs/smart-contracts/advanced-features/composite-query
- Ask AI how to call a canister by ID in Motoko
- Ask AI for an example of Management Canister call to check the controllers of my actor (canister)

### ✅ **Challenge 4: Implement Timers**

- create a "job" method (meant to be called by the Timer);
- create a **"cron"** job that runs "every 1h".
- create a **"queued"** job that you set to run in "1 min".

#### 💡 Tips
-  Check docs about what are [Timers](https://internetcomputer.org/docs/current/developer-docs/smart-contracts/advanced-features/periodic-tasks/)
-  And how to implement them in [Motoko](https://internetcomputer.org/docs/current/motoko/main/writing-motoko/timers)

### ✅ **Challenge 5: Set Up a CICD Pipeline (with Testing and Linting) and Monitoring**

- Add **tests** to your repo (suggest Mops Test with PocketIC as param)
- Run tests, format lint and audits on **github workflow (Action)**
- Deploy on mainnet (ask Tiago for Faucet Coupon) and:
  - Implement monitoring with CycleOps
  - Cause a trap and then see it in the logs (and also query stats)
 
#### 💡 Tips
- Understand about [Mops Test](https://mops.one/test) and how its using already Pocket IC (see [docs](https://docs.mops.one/cli/mops-test))
- See an example of a github workflow [here](https://github.com/obsidian-tears/obsidian_tears_frontend_backend/blob/main/.github/workflows/ci.yml)
- Learn/claim your cycles with [Faucet Coupons](https://anv4y-qiaaa-aaaal-qaqxq-cai.ic0.app/)
- Monitor your cycles at [CycleOps](https://cycleops.dev/)
- Ask AI to explain about "dfx logs" and "dfx canister stats" (for stats on amount of query calls)

---

## 💡 Freedom to Innovate

Unlike the beginner challenge, the Advanced Backend Challenge gives you more freedom on how you want to implement. You're encouraged to explore, innovate, and build good backend solutions on ICP.

### 📝 Example Template Code

The code provided in this repository already has a few methods to help you get started and guide on what is expected. Feel free to modify, extend, or completely re-imagine it as you work on your advanced backend challenge. Use it as a reference while exploring the advanced features of ICP.

### 💡 Do Your Own Research:

Explore the links provided in this challenge to dive deeper into each topic.
We strongly recommend asking the Internet Computer AI (https://internetcomputer.org/), before doing a Google Search or asking fellow devs.

---

## 📖 Learning Outcomes

### 🌍 **HTTP Outcalls (Fetching External API Data)**

- Understanding **HTTP outcalls** on ICP
- How to request external data from an API

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
