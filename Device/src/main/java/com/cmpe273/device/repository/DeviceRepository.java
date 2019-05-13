package com.cmpe273.device.repository;

import org.springframework.data.repository.CrudRepository;
import com.cmpe273.device.model.Device;
import java.util.List;

public interface DeviceRepository extends CrudRepository<Device, Integer> {
    Device findByDeviceName(String deviceName);
}
