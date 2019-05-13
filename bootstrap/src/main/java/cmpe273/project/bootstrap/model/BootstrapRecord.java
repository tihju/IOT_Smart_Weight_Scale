package cmpe273.project.bootstrap.model;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class BootstrapRecord {

	@Id
	private Integer deviceId;
    private Boolean bootstrapped;
    
    public BootstrapRecord() {}

	public Integer getDeviceId() {
		return deviceId;
	}

	public void setDeviceId(Integer deviceId) {
		this.deviceId = deviceId;
	}

	public Boolean getBootstrapped() {
		return bootstrapped;
	}

	public void setBootstrapped(Boolean bootstrapped) {
		this.bootstrapped = bootstrapped;
	}

	@Override
	public String toString() {
		return String.format(
				"BootstrapRecord[deviceId=%d, deviceName='%s']",
				deviceId, Boolean.toString(bootstrapped));
	}

}
