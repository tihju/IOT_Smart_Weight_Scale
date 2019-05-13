package com.cmpe273.device.controller;

import com.cmpe273.device.model.Device;
import com.cmpe273.device.model.Record;

import com.cmpe273.device.repository.DeviceRepository;
import com.cmpe273.device.repository.RecordRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.web.bind.annotation.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(path="/dm")
public class DmController {

	// Spring mysql with jpa reference: https://spring.io/guides/gs/accessing-data-mysql/
	@Autowired
	private DeviceRepository deviceRepository;

	@Autowired
	private RecordRepository recordRepository;

	/**
	 * Sample test
	 * GET: http://localhost:8080/dm/record/1
	 * Description: achieve weight record by giving recordId
	 */
	@GetMapping(value = "/record/{recordId}")
	public @ResponseBody Record getRecord(@PathVariable String recordId) {
		Record record = recordRepository.findById(Integer.valueOf(recordId)).get();
//		Record record = recordRepository.findById(4).get();
		return record;
	}

	/**
	 * Sample test
	 * GET: http://localhost:8080/dm/device/1
	 * Description: discover device information by giving deviceId
	 */
	@GetMapping(value = "/device/{deviceId}")
	public @ResponseBody Device getDevice(@PathVariable String deviceId) {
		Device device = deviceRepository.findById(Integer.valueOf(deviceId)).get();
		return device;
	}

	/**
	 * Sample test
	 * PUT: http://localhost:8080/dm/set/device/1
	 * RequestBody: { "flag" : "true" }
	 * Description: set device's registered flag to true/false by giving a deviceId
	 */
	@PutMapping(value = "/set/device/{deviceId}")
	public @ResponseBody ResponseEntity<?> resetDevice(@PathVariable String deviceId, @RequestBody Map<String, String> payload) {
		Device device = deviceRepository.findById(Integer.valueOf(deviceId)).get();
		device.setRegistered(Boolean.valueOf(payload.get("flag")));
		deviceRepository.save(device);
		return new ResponseEntity<String>(HttpStatus.OK);
	}

	/**
	 * Sample test
	 * POST: http://localhost:8080/dm/create/record/D1/C2/U1
	 * { "weight": "66.6" }
	 * Description: create a record tuple in record table by giving deviceId, clientId, userId
	 */
	@PostMapping(value = "/create/record/{deviceName}/{clientId}/{userId}")
	public @ResponseBody ResponseEntity<?> createRecord(@PathVariable String deviceName, @PathVariable String clientId,
										  @PathVariable String userId, @RequestBody Map<String, String> payload) {
		Record record = new Record();

		Integer curId = recordRepository.getRecordCount();
		record.setRecordId(curId + 1);
		record.setDeviceName(deviceName);
		record.setClientId(clientId);
		record.setUserId(userId);

		if (payload.containsKey("weight")) {
			record.setWeight(Double.valueOf(payload.get("weight")));
		}

		recordRepository.save(record);
		return new ResponseEntity<String>(HttpStatus.OK);
	}

	/**
	 * Sample test
	 * DELETE: http://localhost:8080/dm/delete/record
	 * Description: delete all records in record table
	 */
	@DeleteMapping(value = "/delete/record")
	public @ResponseBody ResponseEntity<?> deleteRecord() {
		recordRepository.deleteAll();
		System.out.println("delete successful");
		return new ResponseEntity<String>(HttpStatus.OK);
	}

}
