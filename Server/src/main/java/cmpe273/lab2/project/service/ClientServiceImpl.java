package cmpe273.lab2.project.service;

import cmpe273.lab2.project.models.*;
import cmpe273.lab2.project.repository.ClientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class ClientServiceImpl implements ClientService {
    @Autowired
    public JavaMailSender emailSender;

    private final ClientRepository clientRepository;

    public ClientServiceImpl(ClientRepository clientRepository){
        this.clientRepository = clientRepository;
    }

    public Client createClient(Client client){
        return clientRepository.save(client);
    }

    public Client getClient(String clientId){
        return clientRepository.getByClientId(clientId);
    }

    public List<Client> getAllClients(){
        return clientRepository.findAll();
    }

    public boolean existsClient(String clientId){
        return clientRepository.existsByClientId(clientId);
    }

    public User getUser(String clientId, String userId){

        if(clientRepository.existsByClientId(clientId)){
            Client client = getClient(clientId);
            HashMap<String, User> users = client.getUsers();
            if(users.containsKey(userId)){
                return users.get(userId);
            }
        }
        return null;
    }

    public List<User> getUsers(String clientId){

        if(clientRepository.existsByClientId(clientId)){
            Client client = getClient(clientId);
            HashMap<String, User> users = client.getUsers();
            List<User> list = new ArrayList<>(users.values());
            return list;
        }
        return null;
    }

    public List<Record> getRecords(String clientId, String userId){
        User user = getUser(clientId, userId);
        if(user != null){
            return user.getRecords();
        }
        return null;
    }

    public Device getDevice(String clientId){

        if(clientRepository.existsByClientId(clientId)){
            Client client = getClient(clientId);
            return client.getDevice();
        }
        return null;
    }

    public User addUser(String clientId, User user){

        if(!clientRepository.existsByClientId(clientId)){
            Client client1 = new Client();
            client1.setClientId(clientId);
            createClient(client1);
        }
        Client client = getClient(clientId);
        HashMap<String, User> users = client.getUsers();
        if(user != null && !users.containsKey(user.getUserId())){
            users.put(user.getUserId(), user);
            client.setUsers(users);
            clientRepository.save(client);
            return user;
        }
        return null;
    }

    public void deleteUser(String clientId, String userId){
        if(clientRepository.existsByClientId(clientId)) {
            Client client = getClient(clientId);
            HashMap<String, User> users = client.getUsers();
            if(users.containsKey(userId)){
                users.remove(userId);
                client.setUsers(users);
                clientRepository.save(client);
            }
        }
    }

    public void deleteClient(String clientId){
        if(clientRepository.existsByClientId(clientId)) {
            clientRepository.deleteById(clientId);
        }
    }

    public boolean isPremium(String clientId){
        return clientRepository.getByClientId(clientId).isPremium();
    }

    public boolean isDeviceRegistered(String clientId){
        if(clientRepository.existsByClientId(clientId)){
            Client client = getClient(clientId);
            if(client.getDevice() != null){
                return true;
            }
        }
        return false;
    }

    public Record addRecord(String clientId, String userId, Record record){
        if(clientRepository.existsByClientId(clientId)) {
            Client client = getClient(clientId);
            HashMap<String, User> users = client.getUsers();
            if(users.containsKey(userId)){
                User user = users.get(userId);
                List<Record> records = user.getRecords();
                if(records == null){
                    records = new ArrayList<>();
                }
                records.add(record);
                user.setRecords(records);
                users.put(userId, user);
                client.setUsers(users);
                clientRepository.save(client);
                //TODO show Notification
                return record;
            }
        }
        return null;
    }

    public void deleteRecords(String clientId, String userId){
        if(clientRepository.existsByClientId(clientId)) {
            Client client = getClient(clientId);
            HashMap<String, User> users = client.getUsers();
            if(users.containsKey(userId)) {
                User user = users.get(userId);
                user.setRecords(null);
                users.put(userId, user);
                client.setUsers(users);
                clientRepository.save(client);
            }
        }
    }

    public Device registerDevice(String clientId, String deviceId){
        if(clientRepository.existsByClientId(clientId)){
            Client client = getClient(clientId);
            Device device = client.getDevice();
            if(device == null || device.getDeviceId() != deviceId){
                device = new Device();
                device.setDeviceId(deviceId);
                device.setRegistrationDate(new Date());
                client.setDevice(device);
                clientRepository.save(client);
                return device;
            }
        }
        return null;


    }
    public void deregisterDevice(String clientId){
        if(clientRepository.existsByClientId(clientId)) {
            Client client = getClient(clientId);
            client.setDevice(null);
            clientRepository.save(client);
        }
    }

    public double getPayment(String clientId){
        double amount = 0.0;
        if(!isPremium(clientId)){
            return amount;
        }
        Client client = getClient(clientId);
        for(Map.Entry<String, User> entry: client.getUsers().entrySet()){
            int size = (entry.getValue().getRecords() == null) ? 0 : entry.getValue().getRecords().size();
            amount += size * 0.5;
        }
        if(client.getPaymentHistory() != null){
            for(Payment payment: client.getPaymentHistory()){
                amount -= payment.getAmount();
            }
        }
        //emailBill(clientId, amount);
        return amount;
    }

    private void emailBill(String clientId, double amount){
        SimpleMailMessage message = new SimpleMailMessage();
        String to = getClient(clientId).getEmail();
        String text = "Dear " + clientId + ", your monthly balance is $"
                + amount + ". The due date is 05/01/2019. Please process your payment in the App.";
        message.setTo(to);
        message.setSubject("Monthly Bill from DWMS App");
        message.setText(text);
        emailSender.send(message);
        System.out.println("email sent out");
    }

    public void processPayment(String clientId){
        double amount = getPayment(clientId);
        if(amount == 0){
            return;
        }
        Payment payment = new Payment();
        payment.setAmount(amount);
        payment.setDate(new Date());
        payment.setStatus("Bill is successfully paid");
        Client client = getClient(clientId);
        List<Payment> history = client.getPaymentHistory();
        if(history == null)
            history = new ArrayList<>();
        history.add(payment);
        client.setPaymentHistory(history);
        clientRepository.save(client);
    }

    public void upgrade(String clientId){
        Client client = getClient(clientId);
        client.setPremium(true);
        clientRepository.save(client);
    }

    public void downgrade(String clientId){
        Client client = getClient(clientId);
        client.setPremium(false);
        clientRepository.save(client);
    }

    public Map<String, Object> getAnalytics(String clientId, String userId){
        Client client = getClient(clientId);
        User user = client.getUsers().get(userId);
        List<Record> records = user.getRecords();
        if(records == null){
            Map<String, Object> result = new HashMap<>();
            result.put(userId, "No record has been added yet");
            return result;
        }
        List<Map<Date, String>> diff = new ArrayList<>();
        double targetWeight = user.getTargetWeight();
        for(Record r: records){
            double d = r.getWeight() - targetWeight;
            Map<Date, String> map = new HashMap<>();
            map.put(r.getDate(), "Differ from target weight: " + d + " kg.");
            diff.add(map);
        }
        Map<String, Object> result = new HashMap<>();
        result.put("history analytics", diff);
        result.put("recommended diet", getRecipe());
        return result;
    }

    private Map<String, String> getRecipe(){
        Map<String, String> result = new HashMap<>();

        Map<String, List<String>> recipe = new HashMap<>();
        recipe.put("breakfast", new ArrayList<>());
        recipe.put("lunch", new ArrayList<>());
        recipe.put("dinner", new ArrayList<>());
        List<String> blist = recipe.get("breakfast");
        List<String> llist = recipe.get("lunch");
        List<String> dlist = recipe.get("dinner");
        blist.add("Omelet with various vegetables, fried in butter or coconut oil.");
        blist.add("Soaked oats with orange, banana & almond yogurt on bread");
        blist.add("Creamy oats with apple, breakfast on-the-go");

        llist.add("Grass-fed yogurt with blueberries and a handful of almonds.");
        llist.add("Black bean salad with avocado & goat cheese.");
        llist.add("Avocado cucumber & chicken sandwich.");

        dlist.add("Bunless cheeseburger, served with vegetables and salsa sauce.");
        dlist.add("Tuna hummus wrap");
        dlist.add("Broccoli, apple & walnut salad");

        Random random = new Random();
        int i = random.nextInt(3);
        result.put("breakfast", blist.get(i));
        i = random.nextInt(3);
        result.put("lunch", llist.get(i));
        i = random.nextInt(3);
        result.put("dinner", dlist.get(i));
        return result;
    }

}
