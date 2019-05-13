package cmpe273.project.bootstrap.controller;

import cmpe273.project.bootstrap.model.BootstrapRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import cmpe273.project.bootstrap.repository.BootstrapRecordRepository;

import java.util.Optional;
import java.util.NoSuchElementException;

@RestController
@RequestMapping(path="/bootstrap")
public class BootstrapController {

//	  @Autowired
//    private JdbcTemplate jdbcTemplate;

	@Autowired
	private BootstrapRecordRepository bootstrapRecordRepository;

	private static final String serverUri = "http://localhost:8000";

	/**
	 * Sample test
	 * Post: http://localhost:8888/bootstrap/1
	 * Description: bootstrap the device with provided deviceId.
	 */
	@PostMapping(value = "/{deviceId}")
	public ResponseEntity<?> Bootstrap(@PathVariable Integer deviceId) {

		// Integer.valueOf(deviceId))
		if (checkBootstrapped(deviceId)) {
			System.out.println("deviceId of " + deviceId + " has already been bootstrapped!");
			return new ResponseEntity<>(serverUri, HttpStatus.OK);
		}

		BootstrapRecord bootstrapRecord;

		if (!containDevice(deviceId)) {
			bootstrapRecord = new BootstrapRecord();
			bootstrapRecord.setDeviceId(deviceId);
		} else {
			bootstrapRecord = bootstrapRecordRepository.findById(deviceId).get();
		}

		bootstrapRecord.setBootstrapped(true);
		bootstrapRecordRepository.save(bootstrapRecord);

		System.out.println("deviceId of " + deviceId + " has been successfully bootstrapped!");
		return new ResponseEntity<>(serverUri, HttpStatus.OK);
	}

	private boolean checkBootstrapped(Integer deviceId) {

		if (!containDevice(deviceId)) {
			return false;
		}

		BootstrapRecord bootstrapRecord = bootstrapRecordRepository.findById(deviceId).get();

		if (!bootstrapRecord.getBootstrapped()) {
			return false;
		}

		return true;
	}

	private boolean containDevice(Integer deviceId) {

		try {
			bootstrapRecordRepository.findById(deviceId).get();
		} catch (NoSuchElementException e) {
			return false;
		}

		return true;
	}

	//    /**
//     * Sample test
//     * PUT: http://localhost:8888/bootstrap/1
//     * Description: bootstrap the device with provided deviceId.
//     */
//	@PutMapping(value = "/bootstrap/{deviceId}")
//	public ResponseEntity<?> doBootstrap(@PathVariable String deviceId) {
//
//		if (checkBootStrap(deviceId)) {
//			System.out.println("deviceId of " + deviceId + " has already been bootstrapped!");
//			return new ResponseEntity<String>(HttpStatus.OK);
//		}
//
//		String sql = "insert into bootstrap (deviceId, bootstrap) values (?, ?)";
//
//		try {
//			jdbcTemplate.update(sql, deviceId, true);
//		} catch (DataAccessException e) {
//			e.printStackTrace();
//			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
//		}
//
//		System.out.println("deviceId of " + deviceId + " has been successfully bootstrapped!");
//		return new ResponseEntity<String>(HttpStatus.OK);
//	}
//
//	private boolean checkBootStrap(String deviceId) {
//        String sql = "select deviceId from bootstrap where deviceId = ?";
//
//        try {
//        	String result = jdbcTemplate.queryForObject(sql, new Object[] {deviceId}, String.class);
//        	return true;
//        } catch (EmptyResultDataAccessException e) {
//    		return false;
//    	}
//
//	}


}
