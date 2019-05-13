package com.cmpe273.device.controller;

import com.cmpe273.device.model.Device;
import com.cmpe273.device.model.Record;
import com.cmpe273.device.repository.DeviceRepository;
import com.cmpe273.device.repository.RecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(path="/test")
public class TestController {

    @Autowired
    private DeviceRepository deviceRepository;

    @Autowired
    private RecordRepository recordRepository;

    // GET: http://localhost:8080/test/add/record?weight=100
    @GetMapping(path="/add/record")
    public @ResponseBody String addRecord (@RequestParam String weight) {
        // @ResponseBody means the returned String is the response, not a view name
        // @RequestParam means it is a parameter from the GET or POST request

        Record record = new Record();
        record.setWeight(Double.valueOf(weight));

        recordRepository.save(record);
        return "Saved";
    }

    // GET: http://localhost:8080/test/add/device?deviceName=D1
    @GetMapping(path="/add/device")
    public @ResponseBody String addDevice (@RequestParam String deviceName) {
        // @ResponseBody means the returned String is the response, not a view name
        // @RequestParam means it is a parameter from the GET or POST request

        Device device = new Device();
        device.setDeviceName(deviceName);

        deviceRepository.save(device);
        return "Saved";
    }

}
