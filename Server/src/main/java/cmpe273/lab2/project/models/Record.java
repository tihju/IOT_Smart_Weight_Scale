package cmpe273.lab2.project.models;

import java.sql.Timestamp;
import java.util.Date;

public class Record {

    private String deviceId;
    private Date date;
    private double weight;

    public Record(){}

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    @Override
    public String toString() {
        return "Record{" +
                "deviceId='" + deviceId + '\'' +
                ", date=" + date +
                ", weight=" + weight +
                '}';
    }
}
