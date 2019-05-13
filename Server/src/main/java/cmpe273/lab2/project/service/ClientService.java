package cmpe273.lab2.project.service;

import cmpe273.lab2.project.models.Client;
import cmpe273.lab2.project.models.Device;
import cmpe273.lab2.project.models.Record;
import cmpe273.lab2.project.models.User;

import java.util.List;
import java.util.Map;

public interface ClientService {

    //client related
    Client createClient(Client client);
    Client getClient(String clientId);
    List<Client> getAllClients();
    boolean existsClient(String clientId);
    void deleteClient(String clientId);

    //user related
    User getUser(String clientId, String userId);
    List<User> getUsers(String clientId);
    User addUser(String clientId, User user);
    void deleteUser(String clientId, String userId);

    //record related
    List<Record> getRecords(String clientId, String userId);
    Record addRecord(String clientId, String userId, Record record);
    void deleteRecords(String clientId, String userId);

    Device getDevice(String clientId);
    boolean isDeviceRegistered(String clientId);
    Device registerDevice(String clientId, String deviceId);
    void deregisterDevice(String clientId);

    //information reporting
    Map<String, Object> getAnalytics(String clientId, String userId);

    //payment service
    boolean isPremium(String clientId);
    double getPayment(String clientId);
    void processPayment(String clientId);
    void upgrade(String clientId);
    void downgrade(String clientId);
}
