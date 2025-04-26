;; Title: SatsLend - Decentralized Bitcoin-Backed Lending Protocol
;; 
;; Summary:
;; A secure and compliant lending protocol for Stacks Layer 2 that enables users
;; to collateralize Bitcoin and borrow STX with automated liquidation mechanisms.
;;
;; Description:
;; SatsLend provides a decentralized lending platform that allows users to deposit
;; BTC as collateral and take out loans in STX. The protocol maintains solvency through
;; configurable collateral ratios, automated liquidation processes, and transparent
;; governance parameters. Built for Stacks Layer 2, it offers seamless interoperability
;; with Bitcoin while ensuring regulatory compliance.

;; Constants
(define-constant CONTRACT-OWNER tx-sender)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-COLLATERAL (err u101))
(define-constant ERR-BELOW-MINIMUM (err u102))
(define-constant ERR-INVALID-AMOUNT (err u103))
(define-constant ERR-ALREADY-INITIALIZED (err u104))
(define-constant ERR-NOT-INITIALIZED (err u105))
(define-constant ERR-INVALID-LIQUIDATION (err u106))
(define-constant ERR-LOAN-NOT-FOUND (err u107))
(define-constant ERR-LOAN-NOT-ACTIVE (err u108))
(define-constant ERR-INVALID-LOAN-ID (err u109))
(define-constant ERR-INVALID-PRICE (err u110))
(define-constant ERR-INVALID-ASSET (err u111))

;; Platform constants
(define-constant VALID-ASSETS (list "BTC" "STX"))

;; Data Variables

;; Platform state and configuration
(define-data-var platform-initialized bool false)
(define-data-var minimum-collateral-ratio uint u150) ;; 150% collateral ratio
(define-data-var liquidation-threshold uint u120) ;; 120% triggers liquidation
(define-data-var platform-fee-rate uint u1) ;; 1% platform fee
(define-data-var total-btc-locked uint u0)
(define-data-var total-loans-issued uint u0)

;; Data Maps

;; Stores detailed information about each loan
(define-map loans
    { loan-id: uint }
    {
        borrower: principal,
        collateral-amount: uint,
        loan-amount: uint,
        interest-rate: uint,
        start-height: uint,
        last-interest-calc: uint,
        status: (string-ascii 20)
    }
)

;; Maps users to their active loans
(define-map user-loans
    { user: principal }
    { active-loans: (list 10 uint) }
)

;; Stores oracle price data for supported assets
(define-map collateral-prices
    { asset: (string-ascii 3) }
    { price: uint }
)

;; Private Functions

;; Calculates the current collateral ratio for a loan
(define-private (calculate-collateral-ratio (collateral uint) (loan uint) (btc-price uint))
    (let
        (
            (collateral-value (* collateral btc-price))
            (ratio (* (/ collateral-value loan) u100))
        )
        ratio
    )
)

;; Calculates accrued interest based on time elapsed
(define-private (calculate-interest (principal uint) (rate uint) (blocks uint))
    (let
        (
            (interest-per-block (/ (* principal rate) (* u100 u144))) ;; Daily interest divided by blocks per day
            (total-interest (* interest-per-block blocks))
        )
        total-interest
    )
)

;; Checks if a loan requires liquidation based on current collateral ratio
(define-private (check-liquidation (loan-id uint))
    (let
        (
            (loan (unwrap! (map-get? loans {loan-id: loan-id}) ERR-LOAN-NOT-FOUND))
            (btc-price (unwrap! (get price (map-get? collateral-prices {asset: "BTC"})) ERR-NOT-INITIALIZED))
            (current-ratio (calculate-collateral-ratio (get collateral-amount loan) (get loan-amount loan) btc-price))
        )
        (if (<= current-ratio (var-get liquidation-threshold))
            (liquidate-position loan-id)
            (ok true)
        )
    )
)