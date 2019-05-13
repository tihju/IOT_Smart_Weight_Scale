package cmpe273.lab2.project.controller;

import cmpe273.lab2.project.service.ClientService;
import cmpe273.lab2.project.service.DeviceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@RestController
public class DeviceController {

    @Autowired
    private ClientService clientService;

    private final DeviceService deviceService;
    public DeviceController(DeviceService deviceService){
        this.deviceService = deviceService;
    }


    // Page for device management
//    @RequestMapping(value = "/device/{deviceId}", method = RequestMethod.GET)
//    public String getDevice(@PathVariable String deviceId, @PathVariable String clientId, Model model) {
//        String options = deviceService.discoverDevice(deviceId);
//
//        model.addAttribute("device", options);
//        return "device";
//    }
//
//    @RequestMapping(value = "/device", method = RequestMethod.GET)
//    public String setUp(Model model) {
//        // model.addAttribute("", clientService.getAllClients());
//        return "device";
//    }

    @RequestMapping(value = "/device/read/{clientId}", method = RequestMethod.GET)
    public String readDevice(@PathVariable String clientId){
        String deviceId = clientService.getDevice(clientId).getDeviceId();
        String recordId = "1";
        String result = deviceService.readDevice(deviceId, clientId, recordId);
        return result;
    }

    @RequestMapping(value = "/device/discover/{clientId}", method = RequestMethod.GET)
    public String discoverDevice(@PathVariable String clientId){
        String deviceId = clientService.getDevice(clientId).getDeviceId();
        String result = deviceService.discoverDevice(deviceId);
        return result;
    }

    @RequestMapping(value = "/device/write/{clientId}", method = RequestMethod.POST)
    public String writeDevice(@PathVariable String clientId){
        String deviceId = clientService.getDevice(clientId).getDeviceId();
        clientService.deregisterDevice(clientId);
        String result = deviceService.writeDevice(deviceId);
        return result;
    }

    @RequestMapping(value = "/device/create/{clientId}/{userId}", method = RequestMethod.PUT)
    public String createDeviceRecord(@PathVariable String clientId, @PathVariable String userId){
        String deviceId = clientService.getDevice(clientId).getDeviceId();
        System.out.println(deviceId);
        String result = deviceService.createDevice(deviceId, clientId, userId);
        return result;
    }

    @RequestMapping(value = "/device/record/{clientId}", method = RequestMethod.DELETE)
    public String deleteDeviceRecord(@PathVariable String clientId){
        //System.out.println("controller called");
        String deviceId = clientService.getDevice(clientId).getDeviceId();
        String result = deviceService.deleteDevice(deviceId);
        return result;
    }

    @RequestMapping(value = "/device/observe/{clientId}", method = RequestMethod.POST)
    public String observe(@PathVariable String clientId, @RequestBody Map<String, String> payload){
        String deviceId = clientService.getDevice(clientId).getDeviceId();
        System.out.println("devideId: " + deviceId);
        if(deviceId == null){
            return "ERROR: No device exists.";
        }
        String result;
        if(payload.get("flag").equals("false")){
            result = deviceService.turnOffObserve(deviceId);
        }else{
            result = deviceService.turnOnObserve(deviceId);
        }
        return result;
        //return "success";
    }



}
