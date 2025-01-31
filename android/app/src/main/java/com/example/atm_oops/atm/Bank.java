package com.example.atm_oops.atm;

import java.util.HashMap;

public class Bank {
    private HashMap<String, Account> accounts;

    public Bank() {
        this.accounts = new HashMap<>();
    }

    public Account createAccount(String accountNumber, String pin, double initialBalance) {
        if (!accounts.containsKey(accountNumber)) {
            Account newAccount = new Account(accountNumber, pin, initialBalance);
            accounts.put(accountNumber, newAccount);
            return newAccount;
        }
        return null; // Account already exists
    }

    public Account getAccount(String accountNumber) {
        return accounts.get(accountNumber);
    }
}
