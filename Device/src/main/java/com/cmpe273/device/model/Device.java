package com.cmpe273.device.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Column;

@Entity
public class Device {

    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private Integer deviceId;
    private String deviceName = null;
    private String modelYear = null;
    private Integer batteryLevel = null;
    private Boolean registered = false;
    private Boolean notified = false;

    public Device() {}

    @Column(nullable = true)
    public Integer getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(Integer deviceId) {
        this.deviceId = deviceId;
    }

    @Column(nullable = true)
    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    @Column (nullable = true)
    public String getModelYear() {
		return modelYear;
	}

    public void setModelYear(String modelYear) {
        this.modelYear = modelYear;
    }

    @Column (nullable = true)
	public Integer getBatteryLevel() {
		return batteryLevel;
	}

	public void setBatteryLevel(int batteryLevel) {
		this.batteryLevel = batteryLevel;
	}

    @Column (nullable = true)
	public Boolean getRegistered() {
		return registered;
	}

	public void setRegistered(Boolean registered) {
		this.registered = registered;
	}

    @Column (nullable = true)
	public Boolean getNotified() {
		return notified;
	}

	public void setNotified(Boolean notified) {
		this.notified = notified;
	}

    @Override
    public String toString() {
        return String.format(
                "Device[deviceId=%d, deviceName='%s', modelYear='%s', batteryLevel='%d', registered='%s', notified='%s']",
                deviceId, deviceName, modelYear, batteryLevel, registered, notified);
    }

//	@Override
//	public String toString() {
//		return "Device{" + "deviceId='" + deviceId + "'" + ", modelYear='" + modelYear + "'"
//				+ ", batteryLevel='" + batteryLevel + "'" + ", registered='" + registered + "'"
//				+ ", notify='" + notified + "'" + "}";
//    }

}
