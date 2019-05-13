package cmpe273.lab2.project.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

@Document(collection = "client")
public class Client {

    @Id
    private String clientId;
    private String email;
    private HashMap<String, User> users = new HashMap<>();
    private Device device;
    private boolean premium;
    private List<Payment> paymentHistory;

    public Client(){}

    public String getClientId() {
        return clientId;
    }

    public void setClientId(String clientId) {
        this.clientId = clientId;
    }

    public HashMap<String, User> getUsers() {
        return users;
    }

    public Device getDevice() {
        return device;
    }

    public void setDevice(Device device) {
        this.device = device;
    }

    public void setUsers(HashMap<String, User> users) {
        this.users = users;
    }

    public boolean isPremium() {
        return premium;
    }

    public void setPremium(boolean premium) {
        this.premium = premium;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public List<Payment> getPaymentHistory() {
        return paymentHistory;
    }

    public void setPaymentHistory(List<Payment> paymentHistory) {
        this.paymentHistory = paymentHistory;
    }

    @Override
    public String toString() {
        return "Client{" +
                "clientId='" + clientId + '\'' +
                ", email='" + email + '\'' +
                ", users=" + users +
                ", device=" + device +
                ", premium=" + premium +
                ", paymentHistory=" + paymentHistory +
                '}';
    }
}
