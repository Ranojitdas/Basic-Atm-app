package com.example.atm_oops;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import com.example.atm_oops.atm.ATM;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "atm_channel";
    private ATM atm = new ATM();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    String accountNumber = call.argument("accountNumber");
                    String pin = call.argument("pin");
                    try {
                        switch (call.method) {
                            case "checkBalance":
                                double balance = atm.checkBalance(accountNumber, pin);
                                result.success("Your balance is: " + balance + "₹");
                                break;
                            case "deposit":
                                double depositAmount = call.argument("amount");
                                atm.deposit(accountNumber, pin, depositAmount);
                                result.success("Deposited " + depositAmount + "₹" + " successfully.");
                                break;
                            case "withdraw":
                                double withdrawAmount = call.argument("amount");
                                atm.withdraw(accountNumber, pin, withdrawAmount);
                                result.success("Withdrew " + withdrawAmount + "₹" + "  successfully.");
                                break;
                            case "changePin":
                                String newPin = call.argument("newPin");
                                atm.changePin(accountNumber, pin, newPin);
                                result.success("PIN changed successfully.");
                                break;
                            default:
                                result.notImplemented();
                        }
                    } catch (IllegalArgumentException e) {
                        result.error("ERROR", e.getMessage(), null);
                    }
                });
    }
}
