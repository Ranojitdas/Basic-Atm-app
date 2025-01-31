package com.example.atm_oops.atm;

import java.util.ArrayList;

public class Account {
    private String accountNumber;
    private String pin;
    private double balance;
    private ArrayList<String> transactionHistory;

    public Account(String accountNumber, String pin, double initialBalance) {
        this.accountNumber = accountNumber;
        this.pin = pin;
        this.balance = initialBalance;
        this.transactionHistory = new ArrayList<>();
        transactionHistory.add("Account created with balance: $" + initialBalance);
    }

    public boolean authenticate(String inputPin) {
        return this.pin.equals(inputPin);
    }

    public double getBalance() {
        return balance;
    }

    public void deposit(double amount) {
        balance += amount;
        transactionHistory.add("Deposited: $" + amount + ", New Balance: $" + balance);
    }

    public boolean withdraw(double amount) {
        if (amount <= balance) {
            balance -= amount;
            transactionHistory.add("Withdrew: $" + amount + ", New Balance: $" + balance);
            return true;
        } else {
            transactionHistory.add("Failed withdrawal attempt: $" + amount);
            return false;
        }
    }

    public void changePin(String newPin) {
        this.pin = newPin;
        transactionHistory.add("PIN changed successfully.");
    }

    public ArrayList<String> getTransactionHistory() {
        return transactionHistory;
    }
}
