package gov.cms.acme.service;

import gov.cms.acme.dto.PatientStatusDTO;

import java.util.List;

public interface PatientStatusService {

    public String updatePatientStatus(PatientStatusDTO patientStatusDTO);

    public PatientStatusDTO getPatientStatusDetail(String patientId, String providerId);

    public List<PatientStatusDTO> getPatientStatusByExp(String patientId);
}
