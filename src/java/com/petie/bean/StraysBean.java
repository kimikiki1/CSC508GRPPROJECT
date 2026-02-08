package com.petie.bean;

import java.io.Serializable;
import java.sql.Date; // Imported for Date handling

public class StraysBean implements Serializable {
    
    // 1. IDs
    private int strayId;  
    private int userId;    
    
    // 2. Data Fields
    private String petType;
    private String locationFound;
    private String petPhoto;
    private String situation;
    private String status;
    
    // CHANGED: Changed from String to java.sql.Date to match Database/Servlet
    private Date dateFound; 
    
    // 3. Extra Field (For displaying reporter name in lists)
    private String reporterName; 

    // Constructor
    public StraysBean() {}

    // --- GETTERS AND SETTERS ---

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

    // Updated Date Getter/Setter to use java.sql.Date
    public Date getDateFound() { return dateFound; }
    public void setDateFound(Date dateFound) { this.dateFound = dateFound; }

    public String getSituation() { return situation; }
    public void setSituation(String situation) { this.situation = situation; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReporterName() { return reporterName; }
    public void setReporterName(String reporterName) { this.reporterName = reporterName; }
}