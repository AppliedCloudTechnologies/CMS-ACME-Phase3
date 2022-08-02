package gov.cms.acme.service;

import gov.cms.acme.dto.PatientAdmitDTO;
import gov.cms.acme.entity.PatientAdmit;

import java.util.List;

public interface PatientAdmitService {

    public PatientAdmitDTO updatePatientAdmit(PatientAdmitDTO patientAdmitDTO);

    public PatientAdmitDTO getPatientAdmitDetail(String patientId, String providerId);

    public List<PatientAdmitDTO> getPatientAdmitByExp(String patientId);
}
