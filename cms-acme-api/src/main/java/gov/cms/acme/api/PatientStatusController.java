package gov.cms.acme.api;


import gov.cms.acme.constants.Constants;
import gov.cms.acme.dto.CmsResponse;
import gov.cms.acme.dto.PatientStatusResponseDTO;
import gov.cms.acme.dto.PatientStatusRequestDTO;
import gov.cms.acme.exception.CmsAcmeException;
import gov.cms.acme.service.PatientStatusService;
import gov.cms.acme.utils.SecurityUtil;
import gov.cms.acme.utils.Utils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/patient-status")
public class PatientStatusController {

   private final PatientStatusService patientStatusService;

   /**
    * @param patientStatusDTO
    * @return status like success or error
    */
   @PutMapping
   @Operation(description = "To update PatientStatus record.")
   @ApiResponse(description = "SUCCESS or ERROR")
   public CmsResponse<?> updateRecord(@io.swagger.v3.oas.annotations.parameters.RequestBody(
           description = "PatientStatusDTO Object.", content = @Content(schema = @Schema(implementation = PatientStatusRequestDTO.class)))
                                    @RequestBody @Valid PatientStatusRequestDTO patientStatusDTO){
      log.info("PatientStatusController#updateRecord");
      log.debug("UserGroup : {}", SecurityUtil.getUserGroup());
      Map<String, Object> claims = SecurityUtil.getUserClaims();
      String facilityId = (String) claims.get("custom:facility_id");
      if(Objects.isNull(facilityId) || facilityId.isBlank()) {
         throw new CmsAcmeException("User Not Allowed to Update Patient Status");
      }
      String result= patientStatusService.updatePatientStatus(patientStatusDTO,facilityId);
      log.debug("Update Patient Status : {}", result);
      return Utils.toResponse(null,result.contains("Invalid")?Constants.ERROR:Constants.SUCCESS,result);
   }

   /**
    * @param providerId
    * @param patientId
    * @return Matching record of PatientStatus.
    */
   @Operation(description = "To fetch PatientStatus record based on patientId and providerId.")
   @ApiResponse(description = "Returns PatientStatus matching provNbr and patientId")
   @GetMapping("/{prov_nbr}/{patientId}")
   public CmsResponse<PatientStatusResponseDTO> getAllForPatientAndProvider(@Parameter(name = "prov_nbr",description = "Provider's id" )
                                                                       @PathVariable(value = Constants.PROVIDER_ID) String providerId,
                                                                            @Parameter(name = "patientId",description = "Patient's id" )
                                                                    @PathVariable(value = Constants.PATIENT_ID) String patientId){
      log.info("PatientStatusController#getAllForPatientAndProvider");
      PatientStatusResponseDTO patientStatusResponseDTO = patientStatusService.getPatientStatusDetail(patientId, providerId);
      return Utils.toResponse(patientStatusResponseDTO,Constants.SUCCESS, Objects.isNull(patientStatusResponseDTO)?"Record not found!":"Record found!");

   }

   /**
    * @param patientId
    * @return List of all patientStatus for a particular patient.
    */
   @Operation(description = "To fetch List of PatientStatus for a particular patient.")
   @ApiResponse(description = "Returns List of all PatientStatus matching given patientId.")
   @GetMapping("/{patientId}")
   public CmsResponse<List<PatientStatusResponseDTO>> getPatientStatusByPatientId(@Parameter(name = "patientId",description = "Patient's id" )@PathVariable(value = Constants.PATIENT_ID) String patientId){
      log.info("PatientStatusController#getPatientStatusByPatientId");
      List<PatientStatusResponseDTO> patientStatusResponseDTO = patientStatusService.getPatientStatusByExp(patientId);
      return Utils.toResponse(patientStatusResponseDTO, Constants.SUCCESS,Objects.isNull(patientStatusResponseDTO)|| patientStatusResponseDTO.isEmpty() ?"Record not found!":"Record found!");
   }


   /**
    * @param ex
    * @return well formatted exception message.
    */
   @ExceptionHandler(CmsAcmeException.class)
   @ResponseStatus(HttpStatus.BAD_REQUEST)
   public CmsResponse handleException(CmsAcmeException ex){
      log.error("Exception occurred- ",ex);
      String errorCode = ex.getErrorCode();
      String description= switch (errorCode){
         case "ConditionalCheckFailedException" -> "Invalid patientId or providerId!";
         default -> ex.getLocalizedMessage();
      };
      return Utils.toResponse(null, Constants.ERROR, description);
   }


   /**
    * @param ex
    * @return validation exception message.
    */
   @ExceptionHandler(MethodArgumentNotValidException.class)
   @ResponseStatus(HttpStatus.BAD_REQUEST)
   public CmsResponse handleException(MethodArgumentNotValidException ex){
      log.error("Exception occurred- ",ex);
      return Utils.toResponse(null, Constants.ERROR, ex.getBindingResult().getAllErrors().get(0).getDefaultMessage());
   }
}
