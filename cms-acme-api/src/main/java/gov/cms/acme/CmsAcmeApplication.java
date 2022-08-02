package gov.cms.acme;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.model.ListTablesResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CmsAcmeApplication implements CommandLineRunner {

	public static void main(String[] args) {
		SpringApplication.run(CmsAcmeApplication.class, args);
	}

	@Autowired
	AmazonDynamoDB amazonDynamoDB;

	@Override
	public void run(String... args) throws Exception {
		ListTablesResult listTablesResult = amazonDynamoDB.listTables();
		listTablesResult.getTableNames().forEach(System.out::println);
	}
}
