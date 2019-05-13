package cmpe273.lab2.project.service;

import org.apache.http.impl.client.HttpClients;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class DeviceServiceImpl implements DeviceService {

    private String uri;
    private RestTemplate restTemplate;


    public DeviceServiceImpl() {
//        ClientHttpRequestFactory requestFactory = new
//                HttpComponentsClientHttpRequestFactory(HttpClients.createDefault());
        uri = "http://127.0.0.1:8080/";
        restTemplate = new RestTemplate();
    }

    public String turnOnObserve(String deviceId){
        System.out.println("inside turnOnObserve service");
        String url = uri + "ir/observe/device/" + deviceId;
        Map<String, String> request = new HashMap<>();
        request.put("flag", "true");
       ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
       System.out.println("returned");
       return response.getStatusCode().toString();
       // return "";
    }

    public String turnOffObserve(String deviceId){
        String url = uri + "ir/observe/device/" + deviceId;
        Map<String, String> request = new HashMap<>();
        request.put("flag", "false");

        ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);

        return response.getStatusCode().toString();
    }

    public String readDevice(String deviceId, String clientId, String recordId){
        String url = uri + "dm/record/" + recordId;
        ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
        return response.getBody();
    }

    public String discoverDevice(String deviceId){
        String url = uri + "dm/device/" + deviceId;
        ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
        return response.getBody();
    }

    public String writeDevice(String deviceId){
        String url = uri + "dm/set/device/" + deviceId;
        Map<String, String> request = new HashMap<>();
        request.put("flag", "false");
        restTemplate.put(url, request);
        return "Success";
    }

    public String createDevice(String deviceId, String clientId, String userId){
        System.out.println("inside service");
        String url = uri + "dm/create/record/" + deviceId + "/" + clientId + "/" + userId;
        Map<String, String> request = new HashMap<>();
        request.put("weight", "55.5");
        ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
        System.out.println("response"+response.getStatusCode().toString());
        return response.getStatusCode().toString();
    }

    public String deleteDevice(String deviceId){
        String url = uri + "dm/delete/record";
        System.out.println("delete service called");
        restTemplate.delete(url);
        return "Success";
    }

}
