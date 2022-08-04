package gov.cms.acme.entity;


import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBIndexHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBIndexRangeKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;
import lombok.Data;

@Data
@DynamoDBTable(tableName = "patient_admit_out")
public class PatientAdmitOut {

    @DynamoDBHashKey
    private String uuid;
    @DynamoDBIndexHashKey(globalSecondaryIndexName = "pat_id", attributeName = "pat_id")
    private String patId;
    @DynamoDBIndexRangeKey(globalSecondaryIndexName = "pat_id", attributeName = "prov_nbr")
    private String provNbr;

}
