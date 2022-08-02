package gov.cms.acme.dto;


import gov.cms.acme.entity.AdmitStatus;
import gov.cms.acme.entity.DisasterType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PatientAdmitDTO extends AuditEntityDTO {

    @NotBlank(message = "PatientId Required.")
    private String patientId;
    @NotBlank(message = "ProviderId Required.")
    private String providerId;
    private Date admitDate;
    
    private DisasterType disasterType;
    private AdmitStatus status;
    private Date statusUpdateDate;
    private Date dateOfDeath;
    private String notes;

}
