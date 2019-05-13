package cmpe273.lab2.project.controller;

import cmpe273.lab2.project.models.Client;
import cmpe273.lab2.project.models.Device;
import cmpe273.lab2.project.models.User;
import cmpe273.lab2.project.repository.ClientRepository;

import cmpe273.lab2.project.service.ClientService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ClientController {

    private final ClientService clientService;

    public ClientController(ClientService clientService) {
        this.clientService = clientService;
    }

    // Homepage
//    @RequestMapping(value = "/", method = RequestMethod.GET)
//    public String index() {
//        return "index";
//    }
//
//    @RequestMapping(value = "/clients", method = RequestMethod.GET)
//    public String list(Model model) {
//        model.addAttribute("clients", clientService.getAllClients());
//        return "clients";
//    }
//
//    @RequestMapping(value = "/client/{clientId}", method = RequestMethod.GET)
//    public String getClient(@PathVariable String clientId, Model model) {
//        if(clientId == null){
//            return HttpStatus.BAD_REQUEST.toString();
//        }
//        if (!clientService.existsClient(clientId)) {
//            return HttpStatus.NOT_FOUND.toString();
//        }
//        model.addAttribute("client", clientService.getClient(clientId));
//        return "clientshow";
//    }
//
//    @RequestMapping(value= {"/client/register"}, method=RequestMethod.GET)
//    public String register(Model model) {
//        model.addAttribute("client", new Client());
//
//        return "registerform";
//    }

    @RequestMapping(value = "/client/{clientId}", method = RequestMethod.GET)
    public ResponseEntity<?> getClient(@PathVariable String clientId) {
        if(clientId == null){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        if (clientService.existsClient(clientId)) {
            return new ResponseEntity<>(clientService.getClient(clientId), HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @RequestMapping(value = "/client/{clientId}/user", method = RequestMethod.GET)
    public ResponseEntity<?> getUsers(@PathVariable String clientId) {
        if(clientId == null){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        if (clientService.existsClient(clientId)) {
            return new ResponseEntity<>(clientService.getUsers(clientId), HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @RequestMapping(value = "/clients", method = RequestMethod.GET)
    public ResponseEntity<?> getClients() {
        return new ResponseEntity<>(clientService.getAllClients(), HttpStatus.OK);
    }


    /**
     * Sample test
     * POST: http://localhost:8000/create
     * required: clientId
     * payload: {
     *     clientId: aaa123,
     *     email: aaa123@gmail.com
     *     name: Alice,
     *     premium: 0/1,
     *     targetWeight: 50.0
     * }
     * Description: create a client
     */
    @RequestMapping(value = "/client/create", method = RequestMethod.POST)
    public ResponseEntity<?> addNewClient(@RequestBody Map<String, Object> payload) {

        if(payload == null || !payload.containsKey("clientId")){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        String clientId = (String) payload.get("clientId");
        if(clientService.existsClient(clientId)){
            return new ResponseEntity<>("ClientId already exists", HttpStatus.BAD_REQUEST);
        }
        Client client = new Client();
        client.setClientId(clientId);
        if(payload.containsKey("email")){
            client.setEmail((String) payload.get("email"));
        }
        if(payload.containsKey("premium") && (int)payload.get("premium") == 1){
            client.setPremium(true);
        }else{
            client.setPremium(false);
        }
        User user = new User();
        user.setUserId(clientId);
        if(payload.containsKey("targetWeight")){
            user.setTargetWeight((double) payload.get("targetWeight"));
        }
        if(payload.containsKey("name")){
            user.setName((String) payload.get("name"));
        }
        HashMap<String, User> map = new HashMap<>();
        map.put(clientId, user);
        client.setUsers(map);
        clientService.createClient(client);
        return new ResponseEntity(client, HttpStatus.OK);
       // clientService.createClient(client);

      //  return "redirect:/client/" + client.getClientId();
    }

    @RequestMapping(value = "/payment/{clientId}", method = RequestMethod.GET)
    public ResponseEntity<?> getPayment(@PathVariable String clientId) {
        if(clientId == null){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        double amount = clientService.getPayment(clientId);
        Map<String, Object> result = new HashMap<>();
        result.put("clientId", clientId);
        result.put("balance", amount);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @RequestMapping(value = "/payment/{clientId}", method = RequestMethod.POST)
    public ResponseEntity<?> processPayment(@PathVariable String clientId, @RequestBody Map<String, Object> payload) {
        if(clientId == null || payload == null){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        clientService.processPayment(clientId);
        return new ResponseEntity<>(clientService.getClient(clientId), HttpStatus.OK);
    }

    @RequestMapping(value = "/upgrade/{clientId}", method = RequestMethod.POST)
    public ResponseEntity<?> upgrade(@PathVariable String clientId){
        if(clientId == null){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        clientService.upgrade(clientId);
        return new ResponseEntity<>("Upgrade to premium successfully.", HttpStatus.OK);
    }

    @RequestMapping(value = "/downgrade/{clientId}", method = RequestMethod.POST)
    public ResponseEntity<?> downgrade(@PathVariable String clientId){
        if(clientId == null){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        clientService.downgrade(clientId);
        return new ResponseEntity<>("Downgrade to basic successfully.", HttpStatus.OK);
    }

    @RequestMapping(value = "/device/deregister/{clientId}", method = RequestMethod.POST)
    public ResponseEntity<?> deregisterDevice(@PathVariable String clientId){
        //System.out.println("controller called");
        clientService.deregisterDevice(clientId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
