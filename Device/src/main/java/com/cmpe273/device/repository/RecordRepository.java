package com.cmpe273.device.repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import com.cmpe273.device.model.Record;

public interface RecordRepository extends CrudRepository<Record, Integer> {

    @Query(value = "select count(*) from record", nativeQuery = true)
    public Integer getRecordCount();

}
