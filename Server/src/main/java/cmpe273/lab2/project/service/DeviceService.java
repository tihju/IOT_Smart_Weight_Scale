package cmpe273.lab2.project.service;

public interface DeviceService {

    String turnOnObserve(String deviceId);
    String turnOffObserve(String deviceId);
    String readDevice(String deviceId, String clientId, String recordId);
    String discoverDevice(String deviceId);
    String writeDevice(String deviceId);
    String createDevice(String deviceId, String clientId, String userId);
    String deleteDevice(String deviceId);
}
