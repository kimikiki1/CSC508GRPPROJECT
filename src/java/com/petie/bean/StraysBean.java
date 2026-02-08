package com.petie.bean;
import java.io.Serializable;

public class StraysBean implements Serializable {
    
    // 1. CHANGED: Renamed to match Database Column 'STRAY_ID'
    private int strayId;  
    
    private int userId;    
    private String petType;
    private String locationFound;
    private String petPhoto;
    private String dateFound;
    private String situation;
    private String status;
    
    // 2. This stores the reporter's Full Name (fetched via JOIN)
    private String reporterName; 

    public StraysBean() {}

    // --- GETTERS AND SETTERS ---

    // Updated ID Getter/Setter
    public int getStrayId() { return strayId; }
    public void setStrayId(int strayId) { this.strayId = strayId; }

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

    // Reporter Name Getter/Setter
    public String getReporterName() { return reporterName; }
    public void setReporterName(String reporterName) { this.reporterName = reporterName; }
}