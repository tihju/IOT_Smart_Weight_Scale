//package com.cmpe273.device.controller;
//
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.web.client.RestTemplate;
//
//import java.util.HashMap;
//import java.util.Map;
//
//@RestController
//public class ClientController {
//
//    private final String uri = "http://localhost:8000/";
//    private RestTemplate restTemplate = new RestTemplate();
//
//    public String getAllClients(){
//        return restTemplate.getForObject(uri, String.class);
//    }
//
//    public String addClient(String clientId){
//        String url = uri + "create";
//        Map<String, String> request = new HashMap<>();
//        request.put("clientId", clientId);
//
//        ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
//        return response.toString();
//    }
//
//    public String getClient(String clientId){
//        String url = uri + clientId;
//        ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
//
//        return response.toString();
//    }
//
//}
