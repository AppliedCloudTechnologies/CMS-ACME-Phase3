package gov.cms.acme.entity;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBRangeKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;
import lombok.Data;

import java.util.Date;

@Data
@DynamoDBTable(tableName = "patient-admit")
public class PatientAdmit extends AuditEntity {

    @DynamoDBHashKey
    private String patientId;

    @DynamoDBRangeKey
    private String providerId;

//    @DynamoDBIgnore
    @DynamoDBAttribute
    private Date admitDate;
    @DynamoDBAttribute
    private String disasterType;
    @DynamoDBAttribute
    private String status;
    @DynamoDBAttribute
    private Date statusUpdateDate;
    @DynamoDBAttribute
    private Date dateOfDeath;
    @DynamoDBAttribute
    private String notes;

}
