package com.cmpe273.device.controller;

import com.cmpe273.device.model.Device;
import com.cmpe273.device.repository.DeviceRepository;
import com.cmpe273.device.repository.RecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping(path="/ir")
public class IrController {

    @Autowired
    private DeviceRepository deviceRepository;

    /**
     * Sample test
     * PUT: http://localhost:8080/ir/observe/device/1
     * RequestBody: { "flag" : "true" }
     * Description: set device's notified flag to true/false by giving a deviceId
     */
    @PostMapping(value = "/observe/device/{deviceId}")
    public ResponseEntity<?> observe(@PathVariable String deviceId, @RequestBody Map<String, String> payload) {
        Device device = deviceRepository.findById(Integer.valueOf(deviceId)).get();
        device.setNotified(Boolean.valueOf(payload.get("flag")));
        deviceRepository.save(device);
        return new ResponseEntity<>(HttpStatus.OK);
    }

//	/**
//	 * Sample test
//	 * POST: http://localhost:8080/observe/A2/testUser2
//	 * {"flag": 0/1}
//	 * Description: turn on/off observe function by giving deviceId and userId
//	 */
//	@RequestMapping(value = "/observe/{deviceId}/{userId}", method = RequestMethod.POST)
//	public ResponseEntity<?> setObserve(@PathVariable String deviceId, @PathVariable String userId,
//                                        @RequestBody Map<String, String> payload) {
//
//		String sql = "update device set notify = ? where deviceId = ?";
//
//		String sql2 = "select * from record where userId = ? and deviceId = ?";
//
//		List<Record> result = jdbcTemplate.query(sql2, new Object[] {userId, deviceId}, new RowMapper<Record>() {
//			public Record mapRow(ResultSet rs, int rowNum) throws SQLException {
//				Record r = new Record();
//				r.setDeviceId(rs.getString("deviceId"));
//				r.setUserId(rs.getString("userId"));
//				r.setRecordId(rs.getInt("recordId"));
//				r.setWeight(rs.getDouble("weight"));
//				r.setTime(rs.getTimestamp("time"));
//				return r;
//			}
//		});
//
//		try {
//			jdbcTemplate.update(sql, payload.get("turn"), deviceId);
//		} catch (DataAccessException e) {
//			e.printStackTrace();
//			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
//		}
//		if(payload.get("turn").equals("1")){
//			return new ResponseEntity<>(result, HttpStatus.OK);
//		}
//
//		return new ResponseEntity<String>(HttpStatus.OK);
//	}

}
