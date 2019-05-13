package cmpe273.lab2.project.repository;

import cmpe273.lab2.project.models.Client;
import cmpe273.lab2.project.models.Device;
import cmpe273.lab2.project.models.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClientRepository extends MongoRepository<Client, String> {
    boolean existsByDevice_DeviceId(String deviceId);
    Client getByClientId(String clientId);
    boolean existsByClientId(String clientId);
}
