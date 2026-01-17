package com.petie.bean;

public class StraysBean {
    private int strayId;
    private String icNumber;
    private String petType;
    private String locationFound;
    private String situation;
    private String dateFound;
    private String petPhoto;

    // Getters and Setters
    public int getStrayId() { return strayId; }
    public void setStrayId(int strayId) { this.strayId = strayId; }

    public String getIcNumber() { return icNumber; }
    public void setIcNumber(String icNumber) { this.icNumber = icNumber; }

    public String getPetType() { return petType; }
    public void setPetType(String petType) { this.petType = petType; }

    public String getLocationFound() { return locationFound; }
    public void setLocationFound(String locationFound) { this.locationFound = locationFound; }

    public String getSituation() { return situation; }
    public void setSituation(String situation) { this.situation = situation; }

    public String getDateFound() { return dateFound; }
    public void setDateFound(String dateFound) { this.dateFound = dateFound; }
    
    public String getPetPhoto() { return petPhoto; }
    public void setPetPhoto(String petPhoto) { this.petPhoto = petPhoto; }
}