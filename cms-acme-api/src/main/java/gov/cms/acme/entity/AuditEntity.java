package gov.cms.acme.entity;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBDocument;
import lombok.Data;

import java.util.Date;

@Data
@DynamoDBDocument
public class AuditEntity {


    @DynamoDBAttribute
    private String createdBy;
    @DynamoDBAttribute
    private Date createdAt;
    @DynamoDBAttribute
    private String updatedBy;
    @DynamoDBAttribute
    private Date updatedAt;

}
