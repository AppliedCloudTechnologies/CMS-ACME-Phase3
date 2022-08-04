package gov.cms.acme.service;

import gov.cms.acme.dto.PatientStatusDTO;

import java.util.List;

public interface PatientAdmitService {

    public PatientStatusDTO updatePatientAdmit(PatientStatusDTO patientStatusDTO);

    public PatientStatusDTO getPatientAdmitDetail(String patientId, String providerId);

    public List<PatientStatusDTO> getPatientAdmitByExp(String patientId);
}
