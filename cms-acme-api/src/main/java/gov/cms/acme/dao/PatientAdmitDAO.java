package gov.cms.acme.dao;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBSaveExpression;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBScanExpression;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.ExpectedAttributeValue;
import gov.cms.acme.entity.PatientAdmit;
import gov.cms.acme.exception.CmsAcmeException;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
@Slf4j
@RequiredArgsConstructor
public class PatientAdmitDAO {

    private final DynamoDBMapper mapper;


    public PatientAdmit updatePatientAdmitRecord(PatientAdmit patientAdmit){
        log.info("Going to save PatientAdmit record!");

        DynamoDBSaveExpression saveExpression = new DynamoDBSaveExpression();
        Map expected = new HashMap();
        expected.put("patientId", new ExpectedAttributeValue(new AttributeValue(patientAdmit.getPatientId())).withExists(true));
        expected.put("providerId", new ExpectedAttributeValue(new AttributeValue(patientAdmit.getProviderId())).withExists(true));

        try {
            saveExpression.setExpected(expected);
            mapper.save(patientAdmit, saveExpression);
            return patientAdmit;
        }catch (AmazonServiceException exception) {
            log.error("Error in updating PatientAdmit ",exception);
            String errorResponse = new String(exception.getRawResponse());
            log.debug("ErrorResponse: {}",errorResponse);
            throw new CmsAcmeException(exception.getErrorMessage(), exception.getErrorCode(), errorResponse);
        }
    }

    public PatientAdmit getPatientAdmitRecord(String patientId, String providerId){
        log.info("PatientAdmitDAO#getPatientRecord");
        try {
            log.debug("PatientId: {}, ProviderId: {}", patientId, providerId);
            PatientAdmit patientAdmit = mapper.load(PatientAdmit.class, patientId, providerId);
            return patientAdmit;
        }catch (AmazonServiceException exception) {
            log.error("Error while fetching PatientAdmit ",exception);
            String errorResponse = new String(exception.getRawResponse());
            log.debug("ErrorResponse: {}",errorResponse);
            throw new CmsAcmeException(exception.getErrorMessage(), exception.getErrorCode(), errorResponse);
        }
    }

    public List<PatientAdmit> getPatientAdmitByExp(String patientId){
        log.info("PatientAdmitDAO#getPatientAdmitByExp");
        try {
            log.debug("PatientId: {}",patientId);
            Map<String, AttributeValue> eav = new HashMap<>();
            eav.put(":val1", new AttributeValue().withS(patientId));
            DynamoDBScanExpression scanExpression = new DynamoDBScanExpression()
                    .withFilterExpression("patientId = :val1").withExpressionAttributeValues(eav);
            List<PatientAdmit> scanResult = mapper.scan(PatientAdmit.class, scanExpression);
            return scanResult;
        }catch (AmazonServiceException exception) {
            log.error("Error while fetching PatientAdmit for a patient ",exception);
            String errorResponse = new String(exception.getRawResponse());
            log.debug("ErrorResponse: {}",errorResponse);
            throw new CmsAcmeException(exception.getErrorMessage(), exception.getErrorCode(), errorResponse);
        }
    }

}
