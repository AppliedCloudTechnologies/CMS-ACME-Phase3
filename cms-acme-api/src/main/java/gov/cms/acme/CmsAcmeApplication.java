package gov.cms.acme;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@OpenAPIDefinition(info=@Info(title="CMS-ACME API documentation",
		description = "API documentation for CMS-ACME PatientStatus service.",
		license = @License(name = "CMS-ACME license.")))
@SpringBootApplication
public class CmsAcmeApplication {

	public static void main(String[] args) {
		SpringApplication.run(CmsAcmeApplication.class, args);
	}

}
