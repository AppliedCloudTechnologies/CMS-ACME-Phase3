package gov.cms.acme.entity;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBRangeKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;
import lombok.Data;

@Data
@DynamoDBTable(tableName = "patient_status")
public class PatientStatus extends AuditEntity {

    @DynamoDBHashKey(attributeName = "pat_id")
    private String patId;

    @DynamoDBRangeKey(attributeName = "prov_nbr")
    private String provNbr;

    @DynamoDBAttribute(attributeName = "admit_date")
    private String admitDate;
    @DynamoDBAttribute(attributeName = "disaster_type")
    private String disasterType;
    @DynamoDBAttribute
    private String status;
    @DynamoDBAttribute(attributeName = "status_update_date")
    private String statusUpdateDate;
    @DynamoDBAttribute(attributeName = "date_of_death")
    private String dateOfDeath;
    @DynamoDBAttribute
    private String notes;

}
