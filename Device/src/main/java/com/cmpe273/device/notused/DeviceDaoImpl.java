//package com.cmpe273.device.repository;
//
//import cmpe273.lab2.client.controller.ClientController;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.stereotype.Repository;
//
//
//@Repository
//public class DeviceDaoImpl implements DeviceDao {
//
//    @Autowired
//    private JdbcTemplate jdbcTemplate;
//
//    private ClientController clientController = new ClientController();
//
//
//    public String addDevice(String clientId, String deviceId){
//      //  String result = clientController.addDevice(clientId, deviceId);
//      //  System.out.println(result);
//
//        String sql = "insert into device values (?,?)";
//        if (jdbcTemplate == null)
//            System.out.println("null");
//
//        int ret = jdbcTemplate.update(sql, clientId, deviceId);
//        if(ret == 1)
//            System.out.println("New Device Added Successfully");
//
//        return "successful";
//    }
//
//
//}
