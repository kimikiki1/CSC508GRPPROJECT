package com.petie.bean;

import java.io.Serializable;

public class AdoptionRequestBean implements Serializable {
    
    // 1. Fields from Database Table
    private int requestId;
    private int userId;
    private int strayId;
    private String status;

    // 2. Extra Fields for Display (Fetched via SQL JOIN)
    private String userName;
    private String userPhone;
    private String petType;
    private String petPhoto;

    // 3. Constructors
    public AdoptionRequestBean() {}

    // 4. Getters and Setters
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getStrayId() { return strayId; }
    public void setStrayId(int strayId) { this.strayId = strayId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Getters/Setters for Extra Display Fields
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserPhone() { return userPhone; }
    public void setUserPhone(String userPhone) { this.userPhone = userPhone; }

    public String getPetType() { return petType; }
    public void setPetType(String petType) { this.petType = petType; }

    public String getPetPhoto() { return petPhoto; }
    public void setPetPhoto(String petPhoto) { this.petPhoto = petPhoto; }
}