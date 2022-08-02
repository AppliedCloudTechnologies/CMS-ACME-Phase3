package gov.cms.acme.api;


import gov.cms.acme.constants.Constants;
import gov.cms.acme.dto.CmsResponse;
import gov.cms.acme.dto.PatientAdmitDTO;
import gov.cms.acme.exception.CmsAcmeException;
import gov.cms.acme.service.PatientAdmitService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/patient-admit")
@Api(value = "APIs for PatientAdmit records.")
public class PatientAdmitController {

   private final PatientAdmitService patientAdmitService;

   @PutMapping
   @ApiOperation(value = "To update PatientAdmit records.")
   public CmsResponse<PatientAdmitDTO> updateRecord(@ApiParam(value = "PatientAdmit request object.")
                                                       @RequestBody @Valid PatientAdmitDTO patientAdmitDTO){
      log.info("PatientAdmitController#updateRecord");
      PatientAdmitDTO result= patientAdmitService.updatePatientAdmit(patientAdmitDTO);
      return new CmsResponse<>(result, Constants.SUCCESS,false);
   }

   @ApiOperation(value = "To fetch PatientAdmit record based on patientId and providerId")
   @GetMapping("/{providerId}/{patientId}")
   public CmsResponse<PatientAdmitDTO> getAllForPatientAndProvider(@ApiParam(value = "Provider's Id") @PathVariable(value = Constants.PROVIDER_ID) String providerId,
                                                                   @ApiParam(value = "Patient's Id") @PathVariable(value = Constants.PATIENT_ID) String patientId){
      log.info("PatientAdmitController#getAllForPatientAndProvider");
      PatientAdmitDTO patientAdmitDTO= patientAdmitService.getPatientAdmitDetail(patientId, providerId);
      return new CmsResponse<>(patientAdmitDTO, Constants.SUCCESS,false);

   }

   @ApiOperation(value = "To fetch records for a particular patient.")
   @GetMapping("/{patientId}")
   public CmsResponse<List<PatientAdmitDTO>> getPatientAdmitByPatientId(@ApiParam(value = "Patient's Id") @PathVariable(value = Constants.PATIENT_ID) String patientId){
      log.info("PatientAdmitController#getPatientAdmitByExp");
      List<PatientAdmitDTO> patientAdmitDTO= patientAdmitService.getPatientAdmitByExp(patientId);
      return new CmsResponse<>(patientAdmitDTO, Constants.SUCCESS,false);
   }


   @ExceptionHandler(CmsAcmeException.class)
   @ResponseStatus(HttpStatus.BAD_REQUEST)
   public CmsResponse handleException(CmsAcmeException ex){
      log.error("Exception occurred- ",ex);
      return new CmsResponse(ex.getErrorCode(), Constants.ERROR, true);
   }

}
