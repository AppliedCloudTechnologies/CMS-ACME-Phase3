package gov.cms.acme.service;

import gov.cms.acme.dto.PatientStatusResponseDTO;
import gov.cms.acme.dto.PatientStatusRequestDTO;

import java.util.List;

public interface PatientStatusService {

    public String updatePatientStatus(PatientStatusResponseDTO patientStatusResponseDTO);

    public PatientStatusResponseDTO getPatientStatusDetail(String patientId, String providerId);

    public List<PatientStatusResponseDTO> getPatientStatusByExp(String patientId);

    String updatePatientStatus(PatientStatusRequestDTO patientStatusDTO, String facilityId);
}
