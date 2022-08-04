package gov.cms.acme.dao;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.dynamodbv2.datamodeling.*;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import gov.cms.acme.entity.PatientAdmitOut;
import gov.cms.acme.entity.PatientStatus;
import gov.cms.acme.exception.CmsAcmeException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
@Slf4j
@RequiredArgsConstructor
public class PatientAdmitDAO {

    private final DynamoDBMapper mapper;

    /**
     * To upsert PatientStatus in dynamodb.
     * @param patientStatus
     * @return PatientStatus.
     */
    public PatientStatus updatePatientAdmitRecord(PatientStatus patientStatus){
        log.info("PatientAdmitDAO#updatePatientAdmitRecord");
        try {
            log.info("Going to save PatientAdmit record!");
//            int patientAdmitOutCount = getPatientAdmitOut(patientStatus.getPatId(), patientStatus.getProvNbr());
//            log.info("patientAdmitOutCount: {}",patientAdmitOutCount);
//          config for not to update null attributes.
            DynamoDBMapperConfig config = DynamoDBMapperConfig.builder()
                    .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
                    .build();
//          updating records.
            mapper.save(patientStatus, config);
            log.info("PatientAdmit saved successfully!");
            return patientStatus;
        }catch (AmazonServiceException exception) {
            log.error("Error in updating PatientAdmit ",exception);
            String errorResponse = new String(exception.getRawResponse());
            log.debug("ErrorResponse: {}",errorResponse);
            throw new CmsAcmeException(exception.getErrorMessage(), exception.getErrorCode(), errorResponse);
        }
    }

    /**
     * To fetch PatientStatus records based on patientId and providerId.
     * @param patientId
     * @param providerId
     * @return  PatientStatus based on patientId and providerId.
     */
    public PatientStatus getPatientAdmitRecord(String patientId, String providerId){
        log.info("PatientAdmitDAO#getPatientRecord");
        try {
            log.debug("PatientId: {}, ProviderId: {}", patientId, providerId);
//          Fetching record using DynamoDBMapper.load method based on patientId and providerId
            PatientStatus patientStatus = mapper.load(PatientStatus.class, patientId, providerId);
            return patientStatus;
        }catch (AmazonServiceException exception) {
            log.error("Error while fetching PatientAdmit ",exception);
            String errorResponse = new String(exception.getRawResponse());
            log.debug("ErrorResponse: {}",errorResponse);
            throw new CmsAcmeException(exception.getErrorMessage(), exception.getErrorCode(), errorResponse);
        }
    }

    /**
     * To fetch all patientStatus records for a particular patient.
     * @param patientId
     * @return List of PatientStatus for a patient.
     */
    public List<PatientStatus> getPatientAdmitByExp(String patientId){
        log.info("PatientAdmitDAO#getPatientAdmitByExp");
        try {
            log.debug("PatientId: {}",patientId);
//          creating search criteria using queryExpression to fetch records.
            Map<String, AttributeValue> eav = new HashMap<>();
            eav.put(":patientId", new AttributeValue().withS(patientId));
            DynamoDBQueryExpression<PatientStatus> queryExpression = new DynamoDBQueryExpression<PatientStatus>()
                    .withKeyConditionExpression("pat_id = :patientId").withExpressionAttributeValues(eav);
//          Going to fetch records from dynamodb.
            List<PatientStatus> latestReplies = mapper.query(PatientStatus.class, queryExpression);
            return latestReplies;
        }catch (AmazonServiceException exception) {
            log.error("Error while fetching PatientAdmit for a patient ",exception);
            String errorResponse = new String(exception.getRawResponse());
            log.debug("ErrorResponse: {}",errorResponse);
            throw new CmsAcmeException(exception.getErrorMessage(), exception.getErrorCode(), errorResponse);
        }
    }

    /**
     * To get record's count from PatientAdmitOut table for patientId and provNbr.
     * @param patientId
     * @param provNbr
     * @return
     */
    private int getPatientAdmitOut(String patientId, String provNbr){
        int recordCount=0;
        try {
            log.debug("PatientId: {}, ProviderId: {}",patientId,provNbr);
//          creating QueryExpression to get record's count.
            Map<String, AttributeValue> eav = new HashMap<>();
            eav.put(":patientId", new AttributeValue().withS(patientId));
            eav.put(":provNbr", new AttributeValue().withS(provNbr));
            DynamoDBQueryExpression<PatientAdmitOut> queryExpression = new DynamoDBQueryExpression<PatientAdmitOut>()
                    .withIndexName("pat_id")
                    .withConsistentRead(false)
                    .withFilterExpression("pat_id = :patientId and prov_nbr = :provNbr")
                    .withExpressionAttributeValues(eav);

//          fetching record's count.
            recordCount= mapper.count(PatientAdmitOut.class, queryExpression);

        }catch (AmazonServiceException exception) {
            log.error("Error while fetching PatientAdmitOut's count ",exception);
            String errorResponse = new String(exception.getRawResponse());
            log.debug("ErrorResponse: {}",errorResponse);
//            throw new CmsAcmeException(exception.getErrorMessage(), exception.getErrorCode(), errorResponse);
        }
        return recordCount;
    }

}
