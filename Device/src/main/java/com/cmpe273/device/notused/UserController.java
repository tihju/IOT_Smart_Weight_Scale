//package com.cmpe273.device.controller;
//
//import cmpe273.lab2.client.models.Record;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.web.client.RestTemplate;
//
//import java.util.HashMap;
//import java.util.Map;
//
//@RestController
//public class UserController {
//
//    private final String uri = "http://localhost:8000/";
//    private RestTemplate restTemplate = new RestTemplate();
//
//    @Autowired
//    private JdbcTemplate jdbcTemplate;
//
////    public String getUserRecord(String clientId, String userId){
////        String url = uri + clientId + "/" + userId;
////        ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
////        return response.toString();
////    }
////
////    public String addUser(String clientId, User user){
////        String url = uri + clientId + "/create";
////        ResponseEntity<String> response = restTemplate.postForEntity(url, user, String.class);
////        return response.toString();
////    }
//
//    public String addRecord(String clientId, String userId, Record record){
//        String sql = "select notify from device where deviceId = ?";
//        String deviceId = record.getDeviceId();
//        System.out.println("in controller function " + deviceId);
//        String result = jdbcTemplate.queryForObject(sql, new Object[] {deviceId}, String.class);
//
//        if(result != null && result.equals("1")){
//           // System.out.println("sent to server side");
//
//            String url = uri + "records";
//            Map<String, Object> input = new HashMap<>();
//            input.put("clientId", clientId);
//            input.put("userId", userId);
//            Map<String, Object> r = new HashMap<>();
//            r.put("deviceId", record.getDeviceId());
//            r.put("time", record.getTime());
//            r.put("weight", record.getWeight());
//            input.put("record", r);
//            ResponseEntity<String> response = restTemplate.postForEntity(url, input, String.class);
//            System.out.println(response.getBody());
//            //return response.toString();
//            return "Notification: New record has been added to server. " + record.toString();
//        }
//
//        return "Notification is off";
//    }
//
////    public void deleteUser(String clientId, String userId){
////        String url = uri + clientId + "/" + userId;
////        restTemplate.delete(url);
////    }
//
//}
