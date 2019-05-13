package com.cmpe273.device.instance;

import com.cmpe273.device.model.Record;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import com.cmpe273.device.model.Device;
import com.cmpe273.device.repository.DeviceRepository;
import com.cmpe273.device.repository.RecordRepository;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Scanner;

public class DeviceInstance {

	// real singleton device for simulation purpose

	private ApplicationContext context;
	private Device deviceModel;

	private String curClientId;
	private String curUserId;

	private String serverUri = "http://127.0.0.1:8000";
	private static final String bootstrapUri = "http://localhost:8888";

    private static final Scanner scan = new Scanner(System.in);
	private RestTemplate restTemplate = new RestTemplate();

	public DeviceInstance(ApplicationContext context) {

	    this.context = context;

		Device thisDevice = new Device();
		DeviceRepository deviceRepository = context.getBean(DeviceRepository.class);

	    System.out.println("Please enter the deviceName: ");
		thisDevice.setDeviceName(scan.nextLine());

		if (deviceRepository.findByDeviceName(thisDevice.getDeviceName()) != null) {
			this.deviceModel = deviceRepository.findByDeviceName(thisDevice.getDeviceName());
			System.out.println("Device exist...");
			// need to be redo bootstrap
		} else {
			System.out.println("Please enter the modelYear: ");
			thisDevice.setModelYear(scan.nextLine());

			System.out.println("Please enter the batteryLevel: ");
			thisDevice.setBatteryLevel(Integer.valueOf(scan.nextLine()));

			this.deviceModel = deviceRepository.save(thisDevice);
		}

        System.out.println("Please enter the client id: ");
        String curClientId = scan.nextLine();
        this.curClientId = curClientId;

        System.out.println("Please enter the user id: ");
        String curUserId = scan.nextLine();
        this.curUserId = curUserId;

        System.out.println("Device has started!");
	}

	public void bootstrap() {

		if (isBootstrapped()) {
			System.out.println("Device has already been bootstrapped!");
			return;
		}

		String url = bootstrapUri + "/bootstrap" + "/" + deviceModel.getDeviceId();

		Map<String, String> request = new HashMap<>();

		ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
		serverUri = response.getBody();
		System.out.println("Device has been bootstrapped!");
	}

	public void register() {

		if (!isBootstrapped()) {
			System.out.println("\nPlease bootstrap the device first!\n");
			return;
		}

		if (isRegistered()) {
			System.out.println("\nDevice has been already registered!\n");
			return;
		}

		String url = serverUri + "/registration" + "/" + deviceModel.getDeviceId() + "/" + curClientId;

		Map<String, String> request = new HashMap<>();

		ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
		System.out.println(response.toString());
		if (response.getStatusCode() != HttpStatus.OK) {
			return;
		}

		DeviceRepository deviceRepository = context.getBean(DeviceRepository.class);

		deviceModel = deviceRepository.findById(deviceModel.getDeviceId()).get();
		deviceModel.setRegistered(true);
		deviceModel = deviceRepository.save(deviceModel);

		System.out.println("Device has been registered!");
	}

	public void generateRecord() {

		if (!isBootstrapped()) {
			System.out.println("\nPlease bootstrap the device first!\n");
			return;
		}

		if (!isRegistered()) {
			System.out.println("\nPlease register the device first!\n");
			return;
		}

		System.out.println("\nGenerating a weight record...");

		// insert record into record table
        RecordRepository recordRepository = context.getBean(RecordRepository.class);

        Record record = new Record();

		Integer curId = recordRepository.getRecordCount();
		record.setRecordId(curId + 1);
        record.setDeviceName(this.deviceModel.getDeviceName());
        record.setClientId(this.curClientId);
        record.setUserId(this.curUserId);

        System.out.println("Please enter the weight in pound: ");
        String weight = scan.nextLine();
		record.setWeight(Double.valueOf(weight));

		recordRepository.save(record);
		System.out.println("\nRecord generated...");

		// notify server if device notification is on
		notifyServer(record);
	}

	public void notifyServer(Record record) {
		if (!isNotified()) {
			return;
		}

		// send record to server
		String url = serverUri + "/records";

		Map<String, Object> request = new HashMap<>();
		request.put("clientId", curClientId);
		request.put("userId", curUserId);
		Map<String, Object> rc = new HashMap<>();
		rc.put("weight", record.getWeight());
		rc.put("deviceId", deviceModel.getDeviceName());
		request.put("record", rc);
		System.out.println("request: "+request.toString());
		ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);

		if (response.getStatusCode() == HttpStatus.OK) {
			System.out.println("Record has been sent to server!");
		}

	}

	public boolean isBootstrapped() {
		return serverUri != null;
	}

	public boolean isRegistered() {
		DeviceRepository deviceRepository = context.getBean(DeviceRepository.class);
		Device device;

		try {
			device = deviceRepository.findById(deviceModel.getDeviceId()).get();
		} catch (NoSuchElementException e) {
			return false;
		}

		if (device.getRegistered()) {
			return true;
		}

		return false;
	}

	public boolean isNotified() {
		DeviceRepository deviceRepository = context.getBean(DeviceRepository.class);
		Device device;

		try {
			device = deviceRepository.findById(deviceModel.getDeviceId()).get();
		} catch (NoSuchElementException e) {
			return false;
		}

		if (device.getNotified()) {
			return true;
		}

		return false;
	}

	public void operate() {
		System.out.println("Please enter the operation: ");

		while (true) {
			String input = scan.nextLine();

			if (input.equals("end")) {
				System.out.println("End operation");
				return;
			} else if (input.equals("bootstrap")) {
				bootstrap();
			} else if (input.equals("register")) {
				register();
			} else if (input.equals("generate")) {
				generateRecord();
			}
		}

	}

}
