package gov.cms.acme.entity;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBDocument;
import lombok.Data;

@Data
@DynamoDBDocument
public class AuditEntity {


    @DynamoDBAttribute(attributeName = "created_by")
    private String createdBy;
    @DynamoDBAttribute(attributeName = "created_timestamp")
    private String createdTimestamp;
    @DynamoDBAttribute(attributeName = "modified_by")
    private String modifiedBy;
    @DynamoDBAttribute(attributeName = "modified_timestamp")
    private String modifiedTimestamp;

}
