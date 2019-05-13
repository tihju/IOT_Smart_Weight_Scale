package cmpe273.lab2.project.controller;

import cmpe273.lab2.project.models.Client;
import cmpe273.lab2.project.models.Device;
import cmpe273.lab2.project.repository.ClientRepository;
import cmpe273.lab2.project.service.ClientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Date;

@Controller
public class RegistrationController {

    private final ClientService clientService;
    public RegistrationController(ClientService clientService) {
        this.clientService = clientService;
    }

    /**
     * Sample test
     * POST: http://localhost:8000/registration/A1/vv123
     * required: clientId, deviceId
     * return: 400, device already registered
     *         200, device registered successfully
     * Description: register a device
     */
    @RequestMapping(value = "/registration/{deviceId}/{clientId}", method = RequestMethod.POST)
    public ResponseEntity<?> registerDevice(@PathVariable String deviceId, @PathVariable String clientId) {
        if(deviceId == null || clientId == null || !clientService.existsClient(clientId)){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        if(clientService.existsClient(clientId) && clientService.isDeviceRegistered(clientId)) {
           // return new ResponseEntity<>("Device has already been registered", HttpStatus.BAD_REQUEST);
            return new ResponseEntity<>(HttpStatus.OK);
        }
        String s = "Device " + deviceId + " has been registered successfully";
        clientService.registerDevice(clientId, deviceId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @RequestMapping(value = "/registration/{deviceId}/{clientId}", method = RequestMethod.GET)
    public ResponseEntity<?> getDevice(@PathVariable String deviceId, @PathVariable String clientId){
     //   System.out.println("get function called");
        if(deviceId == null || clientId == null){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(clientService.getDevice(clientId), HttpStatus.OK);
    }

//    @RequestMapping(value = "/setup", method = RequestMethod.GET)
//    public String setUp(Model model) {
//       // model.addAttribute("", clientService.getAllClients());
//        return "setup";
//    }

}
