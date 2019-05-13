package com.cmpe273.device;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;

import com.cmpe273.device.instance.DeviceInstance;

@SpringBootApplication
public class DeviceApplication {

    public static void main(String[] args) {

        ApplicationContext context = SpringApplication.run(DeviceApplication.class, args);

        DeviceInstance newDevice = new DeviceInstance(context);

        newDevice.operate();
    }

}
