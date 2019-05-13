package cmpe273.project.bootstrap.repository;

import org.springframework.data.repository.CrudRepository;

import cmpe273.project.bootstrap.model.BootstrapRecord;

public interface BootstrapRecordRepository extends CrudRepository<BootstrapRecord, Integer> {

}
