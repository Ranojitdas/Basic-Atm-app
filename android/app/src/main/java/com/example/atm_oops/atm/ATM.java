package com.example.atm_oops.atm;

import java.util.ArrayList;

public class ATM {
    private Bank bank;

    public ATM() {
        this.bank = new Bank();
        // Create a default account for testing
        bank.createAccount("12345", "1234", 500.0);
    }

    public Bank getBank() {
        return bank;
    }

    public double checkBalance(String accountNumber, String pin) {
        Account account = bank.getAccount(accountNumber);
        if (account != null && account.authenticate(pin)) {
            return account.getBalance();
        }
        throw new IllegalArgumentException("Invalid account number or PIN.");
    }

    public void deposit(String accountNumber, String pin, double amount) {
        Account account = bank.getAccount(accountNumber);
        if (account != null && account.authenticate(pin)) {
            account.deposit(amount);
        } else {
            throw new IllegalArgumentException("Invalid account number or PIN.");
        }
    }

    public void withdraw(String accountNumber, String pin, double amount) {
        Account account = bank.getAccount(accountNumber);
        if (account != null && account.authenticate(pin)) {
            if (!account.withdraw(amount)) {
                throw new IllegalArgumentException("Insufficient balance.");
            }
        } else {
            throw new IllegalArgumentException("Invalid account number or PIN.");
        }
    }

    public void changePin(String accountNumber, String pin, String newPin) {
        Account account = bank.getAccount(accountNumber);
        if (account != null && account.authenticate(pin)) {
            account.changePin(newPin);
        } else {
            throw new IllegalArgumentException("Invalid account number or PIN.");
        }
    }

    public ArrayList<String> getTransactionHistory(String accountNumber, String pin) {
        Account account = bank.getAccount(accountNumber);
        if (account != null && account.authenticate(pin)) {
            return account.getTransactionHistory();
        }
        throw new IllegalArgumentException("Invalid account number or PIN.");
    }
}
