package gov.cms.acme.service.impl;

import gov.cms.acme.dao.PatientAdmitDAO;
import gov.cms.acme.dto.PatientAdmitDTO;
import gov.cms.acme.dto.mapper.PatientAdmitMapper;
import gov.cms.acme.entity.PatientAdmit;
import gov.cms.acme.service.PatientAdmitService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@Slf4j
@RequiredArgsConstructor
public class PatientAdmitServiceImpl implements PatientAdmitService {


    private final PatientAdmitDAO patientAdmitDAO;
    private final PatientAdmitMapper patientAdmitMapper;

    @Override
    public PatientAdmitDTO updatePatientAdmit(PatientAdmitDTO patientAdmitDTO){
        log.info("PatientAdmitServiceImpl#updatePatientAdmit");
        PatientAdmit patientAdmit = patientAdmitDAO.updatePatientAdmitRecord(patientAdmitMapper.toEntity(patientAdmitDTO));
        return patientAdmitMapper.toDto(patientAdmit);
    }

    @Override
    public PatientAdmitDTO getPatientAdmitDetail(String patientId, String providerId) {
        log.info("PatientAdmitServiceImpl#getPatientAdmitDetail");
        PatientAdmit patientAdmitRecord = patientAdmitDAO.getPatientAdmitRecord(patientId, providerId);
        return patientAdmitMapper.toDto(patientAdmitRecord);
    }

    @Override
    public List<PatientAdmitDTO> getPatientAdmitByExp(String patientId) {
        log.info("PatientAdmitServiceImpl#getPatientAdmitByExp");
        List<PatientAdmit> patientAdmitByExp = patientAdmitDAO.getPatientAdmitByExp(patientId);
        return patientAdmitMapper.toDto(patientAdmitByExp);
    }

}
