package com.petie.bean;
import java.io.Serializable;

public class StraysBean implements Serializable {
    private int strayId;  // The Report's ID
    private int userId;   // The User's ID (CRITICAL FIX)
    private String petType;
    private String locationFound;
    private String petPhoto;
    private String dateFound;
    private String situation;
    private String status;

    public StraysBean() {}

    // --- GETTERS AND SETTERS ---
    public int getStrayId() { return strayId; }
    public void setStrayId(int strayId) { this.strayId = strayId; }

    // MAKE SURE YOU HAVE THIS:
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getPetType() { return petType; }
    public void setPetType(String petType) { this.petType = petType; }
    public String getLocationFound() { return locationFound; }
    public void setLocationFound(String locationFound) { this.locationFound = locationFound; }
    public String getPetPhoto() { return petPhoto; }
    public void setPetPhoto(String petPhoto) { this.petPhoto = petPhoto; }
    public String getDateFound() { return dateFound; }
    public void setDateFound(String dateFound) { this.dateFound = dateFound; }
    public String getSituation() { return situation; }
    public void setSituation(String situation) { this.situation = situation; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}