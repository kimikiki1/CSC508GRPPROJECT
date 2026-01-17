package com.petie.bean;
import java.io.Serializable;

public class UserBean implements Serializable {
    private int userId; // New Field
    private String icNumber;
    private String username;
    private String email;
    private String password;
    private String fullName;
    private String phoneNumber;
    private String role;

    public UserBean() {}

    // Add Getter and Setter for ID
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    // ... Keep your existing Getters and Setters for other fields ...
    public String getIcNumber() { return icNumber; }
    public void setIcNumber(String icNumber) { this.icNumber = icNumber; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}