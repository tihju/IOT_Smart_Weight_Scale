package cmpe273.lab2.project;

import cmpe273.lab2.project.controller.DeviceController;
import org.apache.catalina.WebResource;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

import java.util.Scanner;

@SpringBootApplication
public class ProjectApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(ProjectApplication.class);
    }

    public static void main(String[] args) {

        SpringApplication.run(ProjectApplication.class, args);

    }

}
