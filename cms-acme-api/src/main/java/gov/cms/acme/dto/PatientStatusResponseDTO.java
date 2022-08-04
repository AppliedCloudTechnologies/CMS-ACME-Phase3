package gov.cms.acme.dto;


import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import gov.cms.acme.entity.AdmitStatus;
import gov.cms.acme.entity.DisasterType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PatientStatusResponseDTO extends AuditEntityDTO {

    @NotBlank(message = "PatientId is Required!")
    @JsonProperty(value = "pat_id")
    private String patId;
    //    @NotBlank(message = "ProviderNbr is Required!")
    @Schema(accessMode = Schema.AccessMode.READ_ONLY)
    @JsonProperty(value = "prov_nbr")
    private String provNbr;


    @JsonProperty(value = "disaster_type")
    private DisasterType disasterType;
    private AdmitStatus status;
    @Schema(accessMode = Schema.AccessMode.READ_ONLY)
    @JsonProperty(value = "status_update_date")
    private String statusUpdateDate;
    @JsonProperty(value = "date_of_death")
    private String dateOfDeath;
    private String notes;

}
