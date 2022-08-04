package gov.cms.acme.api;


import gov.cms.acme.constants.Constants;
import gov.cms.acme.dto.CmsResponse;
import gov.cms.acme.dto.PatientStatusDTO;
import gov.cms.acme.exception.CmsAcmeException;
import gov.cms.acme.service.PatientAdmitService;
import gov.cms.acme.utils.Utils;
//import io.swagger.annotations.Api;
//import io.swagger.annotations.ApiOperation;
//import io.swagger.annotations.ApiParam;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.Objects;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/patient-admit")
public class PatientAdmitController {

   private final PatientAdmitService patientAdmitService;

   /**
    * @param patientStatusDTO
    * @return status like success or error
    */
   @PutMapping
   @Operation(description = "To update PatientStatus record.")
   @ApiResponse(description = "SUCCESS or ERROR")
   public CmsResponse updateRecord(@Parameter(description = "PatientStatus request object.",name = "patientStatusDTO")
                                    @RequestBody @Valid PatientStatusDTO patientStatusDTO){
      log.info("PatientAdmitController#updateRecord");
      PatientStatusDTO result= patientAdmitService.updatePatientAdmit(patientStatusDTO);
      return Utils.toResponse(null,Constants.SUCCESS,"Record updated Successfully!");
   }

   /**
    * @param providerId
    * @param patientId
    * @return Matching record of PatientStatus.
    */
   @Operation(description = "To fetch PatientStatus record based on patientId and providerId.")
   @ApiResponse(description = "Returns PatientStatus matching provNbr and patientId")
   @GetMapping("/{prov_nbr}/{patientId}")
   public CmsResponse<PatientStatusDTO> getAllForPatientAndProvider(@Parameter(name = "prov_nbr",description = "Provider's id" )
                                                                       @PathVariable(value = Constants.PROVIDER_ID) String providerId,
                                                                    @Parameter(name = "patientId",description = "Patient's id" )
                                                                    @PathVariable(value = Constants.PATIENT_ID) String patientId){
      log.info("PatientAdmitController#getAllForPatientAndProvider");
      PatientStatusDTO patientStatusDTO = patientAdmitService.getPatientAdmitDetail(patientId, providerId);
      return Utils.toResponse(patientStatusDTO,Constants.SUCCESS, Objects.isNull(patientStatusDTO)?"Record not found!":"Record found!");

   }

   /**
    * @param patientId
    * @return List of all patientStatus for a particular patient.
    */
   @Operation(description = "To fetch List of PatientStatus for a particular patient.")
   @ApiResponse(description = "Returns List of all PatientStatus matching given patientId.")
   @GetMapping("/{patientId}")
   public CmsResponse<List<PatientStatusDTO>> getPatientAdmitByPatientId(@Parameter(name = "patientId",description = "Patient's id" )@PathVariable(value = Constants.PATIENT_ID) String patientId){
      log.info("PatientAdmitController#getPatientAdmitByExp");
      List<PatientStatusDTO> patientStatusDTO = patientAdmitService.getPatientAdmitByExp(patientId);
      return Utils.toResponse(patientStatusDTO, Constants.SUCCESS,Objects.isNull(patientStatusDTO)|| patientStatusDTO.isEmpty() ?"Record not found!":"Record found!");
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
