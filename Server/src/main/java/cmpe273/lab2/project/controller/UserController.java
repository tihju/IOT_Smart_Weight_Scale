package cmpe273.lab2.project.controller;

import cmpe273.lab2.project.models.Client;
import cmpe273.lab2.project.models.Record;
import cmpe273.lab2.project.models.User;
import cmpe273.lab2.project.repository.ClientRepository;

import cmpe273.lab2.project.service.ClientService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class UserController {

    private final ClientService clientService;

    public UserController(ClientService clientService) {
        this.clientService = clientService;
    }

    @RequestMapping(value = "/client/{clientId}/user/{userId}", method = RequestMethod.GET)
    public ResponseEntity<?> getUserRecord(@PathVariable String clientId, @PathVariable String userId) {
        if(clientId == null || userId == null){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        if (clientService.existsClient(clientId)) {
            if(clientService.getUser(clientId, userId) != null){
                return new ResponseEntity<>(clientService.getUser(clientId, userId), HttpStatus.OK);
            }
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @RequestMapping(value = "/client/{clientId}/user/create", method = RequestMethod.POST)
    public ResponseEntity<?> addNewUser(@PathVariable String clientId, @RequestBody User user) {
        if(clientId == null || user == null)
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);

        if (clientService.existsClient(clientId)) {
            if(clientService.addUser(clientId, user) != null){
                return new ResponseEntity<>(user, HttpStatus.OK);
            }
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @RequestMapping(value = "records/{clientId}/{userId}", method = RequestMethod.GET)
    public ResponseEntity<?> getRecords(@PathVariable String clientId, @PathVariable String userId) {
        if(clientId == null || userId == null)
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        List<Record> recordList = clientService.getRecords(clientId, userId);
        if(recordList != null){
            return new ResponseEntity<>(recordList, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    /**
     * Sample test
     * POST: http://localhost:8000/records
     * required: clientId, weight
     * payload: {
     *     clientId: aaa123,
     *     userId: aaa123
     *     record: {
     *         weight: 55,
     *         deviceId: A1
     *     }
     * }
     * Description: add a user record
     */
    @RequestMapping(value = "/records", method = RequestMethod.POST)
    public ResponseEntity<?> addRecord(@RequestBody Map<String, Object> payload) {

        if(!payload.containsKey("clientId") || !payload.containsKey("record")){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        String clientId = (String) payload.get("clientId");
        Map<String, Object> r = (Map<String, Object>) payload.get("record");
        if(!clientService.existsClient(clientId)){
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        String userId = (payload.containsKey("userId")) ? (String) payload.get("userId") : clientId;
        Record record = new Record();
        if(r.containsKey("deviceId")){
            record.setDeviceId(String.valueOf(r.get("deviceId")));
        }
        if(r.containsKey("weight")){
            String weight = String.valueOf(r.get("weight"));
            record.setWeight(Double.valueOf(weight));
            record.setDate(new Date());
        }
        clientService.addRecord(clientId, userId, record);
        return new ResponseEntity<>(clientService.getUser(clientId, userId), HttpStatus.OK);
    }

//    @RequestMapping(value = "/{clientId}/{userId}", method = RequestMethod.DELETE)
//    public ResponseEntity<?> deleteUser(@PathVariable String clientId, @PathVariable String userId){
//        if(clientId == null || userId == null){
//            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
//        }
//        clientService.deleteUser(clientId, userId);
//        return new ResponseEntity<>(HttpStatus.OK);
//    }

    @RequestMapping(value = "records/analytics/{clientId}/{userId}", method = RequestMethod.GET)
    public ResponseEntity<?> getAnalytics(@PathVariable String clientId, @PathVariable String userId) {
        if(clientId == null || userId == null){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        if(!clientService.existsClient(clientId)
                || clientService.getClient(clientId).getUsers() == null
                || !clientService.getClient(clientId).getUsers().containsKey(userId)){
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        if(!clientService.getClient(clientId).isPremium()){
            return new ResponseEntity<>("Only premium member can access such feature.", HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(clientService.getAnalytics(clientId, userId), HttpStatus.OK);
    }
}
