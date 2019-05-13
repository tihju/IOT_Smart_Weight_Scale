package com.cmpe273.device.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Column;

import java.sql.Timestamp;

@Entity
public class Record {

	@Id
//	@GeneratedValue(strategy=GenerationType.AUTO)
	private Integer recordId;
	private String deviceName = null;
	private String clientId = null;
    private String userId = null;
    private Double weight = null;
    private Timestamp time = new Timestamp(System.currentTimeMillis());

    public Record() {}

	@Column (nullable = true)
	public Integer getRecordId() {
		return recordId;
	}

	public void setRecordId(Integer recordId) {
		this.recordId = recordId;
	}

	@Column (nullable = true)
	public String getDeviceName() {
		return deviceName;
	}

	public void setDeviceName(String deviceName) {
		this.deviceName = deviceName;
	}

	@Column (nullable = true)
	public String getClientId() {
		return clientId;
	}

	public void setClientId(String clientId) {
		this.clientId = clientId;
	}

	@Column (nullable = true)
    public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	@Column (nullable = true)
	public Double getWeight() { return weight; }

	public void setWeight(Double weight) {
		this.weight = weight;
	}

	@Column (nullable = true)
	public Timestamp getTime() {
		return time;
	}

	public void setTime(Timestamp time) {
		this.time = time;
	}

	@Override
	public String toString() {
		return String.format(
				"Record[recordId=%d, deviceName='%s', clientId='%s', userId='%s', weight='%d', timestamp = '%s']",
				recordId, deviceName, clientId, userId, weight, time.toString());
	}

//	@Override
//	public String toString() {
//		return "Record{" + "userId='" + userId + "'" + ", recordId='" + recordId + "'" + ", deviceId='" + deviceId + "'"
//				+ ", weight='" + weight + "'" + ", time='" + time + "'" + "}";
//	}

}
