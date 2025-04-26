
# SatsLend

## Decentralized Bitcoin-Backed Lending Protocol on Stacks Layer 2

## Overview

**SatsLend** is a decentralized, Bitcoin-collateralized lending protocol built for the Stacks Layer 2 blockchain.  
It enables users to securely deposit Bitcoin (BTC) as collateral and borrow Stacks tokens (STX) while ensuring protocol solvency through transparent governance, automated liquidations, and robust collateral management.

Designed with security, compliance, and Bitcoin interoperability in mind, SatsLend empowers users with decentralized finance capabilities anchored by Bitcoin's unmatched security guarantees.

## Features

- **Bitcoin-Backed Loans**: Deposit BTC as collateral and borrow STX against it.
- **Automated Liquidations**: Positions falling below a safe collateral ratio are liquidated automatically.
- **Configurable Governance**: Adjustable risk parameters such as minimum collateral ratios, liquidation thresholds, and platform fees.
- **Stacks Layer 2 Integration**: Leveraging Stacks’ smart contracts to unlock Bitcoin liquidity without moving BTC off-chain.
- **Transparent Oracle System**: Secure, owner-managed price feeds for BTC and STX.
- **Compliance-Ready Design**: Enables seamless auditability, providing regulatory clarity and transparency.

## Smart Contract Architecture

| Component                 | Description |
| -------------------------- | ----------- |
| `loans` Map                | Stores all loan positions, each with borrower, collateral, amount, and status. |
| `user-loans` Map           | Associates each user with their active loans (up to 10 concurrent loans). |
| `collateral-prices` Map    | Maintains oracle-fed asset prices (BTC, STX). |
| `platform-initialized`     | Boolean flag to secure protocol initialization. |
| `minimum-collateral-ratio` | Defines safe borrowing limits (default: 150%). |
| `liquidation-threshold`    | Threshold that triggers auto-liquidation (default: 120%). |
| `platform-fee-rate`        | Platform fee applied to transactions (default: 1%). |
| `total-btc-locked`         | Tracks the total BTC deposited as collateral. |
| `total-loans-issued`       | Counter for all loans ever created. |

## Key Functionalities

### Platform Management

- **`initialize-platform`**: One-time setup function to activate the platform. Restricted to contract owner.
- **`update-collateral-ratio`**: Governance function to adjust the minimum collateralization requirement.
- **`update-liquidation-threshold`**: Adjusts when auto-liquidations occur.
- **`update-price-feed`**: Updates asset prices (BTC, STX) using owner-controlled oracles.

### Lending Operations

- **`deposit-collateral(amount)`**: Deposit BTC to the protocol for collateralization.
- **`request-loan(collateral, loan-amount)`**: Create a new loan by locking BTC and borrowing STX.
- **`repay-loan(loan-id, amount)`**: Repay a loan principal plus accrued interest.

### Liquidations

- **Automatic Monitoring**: Loans are continuously monitored for collateral ratio compliance.
- **Liquidation Trigger**: If a loan’s ratio falls below the `liquidation-threshold`, the loan is marked as *liquidated* and collateral is seized.

### Read-Only Queries

- **`get-loan-details(loan-id)`**: View detailed loan information.
- **`get-user-loans(user)`**: Retrieve active loans of a user.
- **`get-platform-stats()`**: Platform-wide metrics such as BTC locked, loans issued, and key risk parameters.
- **`get-valid-assets()`**: Lists currently supported assets (BTC, STX).

## Error Handling

SatsLend includes a comprehensive set of error codes to ensure safe interactions:

| Error Code | Description |
|------------|-------------|
| `u100`     | Unauthorized access |
| `u101`     | Insufficient collateral provided |
| `u102`     | Loan below minimum threshold |
| `u103`     | Invalid amount specified |
| `u104`     | Platform already initialized |
| `u105`     | Platform not initialized |
| `u106`     | Invalid liquidation attempt |
| `u107`     | Loan not found |
| `u108`     | Loan not active |
| `u109`     | Invalid loan ID |
| `u110`     | Invalid price value |
| `u111`     | Unsupported asset |

## Risk Management

| Mechanism                 | Purpose |
| -------------------------- | ------- |
| **Minimum Collateral Ratio** | Ensures sufficient collateral against borrowings (default 150%). |
| **Liquidation Threshold**    | Protects the system by liquidating under-collateralized positions (default 120%). |
| **Owner-Governed Parameters** | Allows the protocol to adjust to market conditions (e.g., price volatility). |
| **Price Validation**          | Strict checks on price updates to prevent oracle manipulation. |

## Governance

Initially, the contract owner governs all administrative parameters (e.g., updating collateral ratios, liquidation thresholds, price feeds).  
Future upgrades may decentralize these responsibilities via on-chain governance modules.

## Requirements & Assumptions

- Bitcoin is **locked through trustless Bitcoin Layer 2 mechanisms** on Stacks.
- STX tokens are **native to the Stacks chain** and require no wrapping.
- **Oracle price updates** must be made regularly to maintain accuracy and solvency.

## Future Improvements

- Add decentralized, multi-oracle support for pricing feeds.
- Enable dynamic interest rates based on utilization rates.
- Integrate with additional Bitcoin DeFi protocols for liquidity expansion.
- Implement optional insurance funds to protect against black swan liquidations.
- On-chain governance transition to enable community-led management.

## Contributing

We welcome community contributions!  
Stay tuned for contribution guidelines, issue trackers, and bounty programs.

## Contact

- 🌐 Website: *Coming Soon*
