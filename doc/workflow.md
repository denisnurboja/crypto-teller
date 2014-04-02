# Starting an anonymous session

  1. POST /users

```json
{
  "user": {
    "email": "you@example.com",
    "password": "SooperSecure!!"
  }
}
```

  2. Keep temporary password in browser session, provide QR code or email delivery
  3. Once session is over, discard any tokens or passwords

# Generating receive address

  1. GET  /account/addresses?currency=DOGE
  2. If address available, we are done
  3. POST /account/addresses

```json
{
  "address": {
    "currency": "DOGE",
    "label": "optional label"
  }
}
```

  4. In background, POST /api?method=generatenewaddress&currency_code=DOGE (background)
  5. Creates a new address object, returns it

# Generating new wallet

  1. Use http://brainwallet.org

# Receiving a crypto deposit

  1. Background job scans Cryptsy for transactions
  2. Any new deposits will be matched against addresses collection
  3. Looks up spot price for currency, creates sell order
  4. Credits account with total

# Withdrawing to crypto

  1. POST /orders

```json
{
  "order": {
    "amount": 50.00,
    "direction": "sell",
    "address": "xxx",
    "currency": "DOGE"
  }
}
```

  2. If balance is sufficient, background worker will perform necessary conversions and withdraw requests
  3. User will be notified of success or failure

# Depositing cash

  1. POST /transfers

```json
{
  "transfer": {
    "amount": 15.00,
    "direction": "deposit"
  }
}
```

  2. Admin sees pending deposit, can approve or reject
  3. User will be notified of success or failure

# Withdrawing cash

  1. POST /transfers

```json
{
  "transfer": {
    "amount": 15.00,
    "direction": "withdrawal"
  }
}
```

  2. If balance is sufficient, transaction will be considered for approval
  3. Admin sees pending withdrawal, can approve or reject
  4. User will be notified of success or failure
