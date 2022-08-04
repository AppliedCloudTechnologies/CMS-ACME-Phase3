package gov.cms.acme.service.impl;

import gov.cms.acme.dto.PatientStatusDTO;
import gov.cms.acme.entity.PatientStatus;
import gov.cms.acme.utils.Utils;
import gov.cms.acme.dao.PatientAdmitDAO;
import gov.cms.acme.dto.mapper.PatientAdmitMapper;
import gov.cms.acme.service.PatientAdmitService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;


@Service
@Slf4j
@RequiredArgsConstructor
public class PatientAdmitServiceImpl implements PatientAdmitService {


    private final PatientAdmitDAO patientAdmitDAO;
    private final PatientAdmitMapper patientAdmitMapper;

    /**
     * to update patientStatus.
     * @param patientStatusDTO
     * @return
     */
    @Override
    public PatientStatusDTO updatePatientAdmit(PatientStatusDTO patientStatusDTO){
        log.info("PatientAdmitServiceImpl#updatePatientAdmit");
//      setting current datetime to statusUpdateDate and ModifiedTimestamp.
        patientStatusDTO.setStatusUpdateDate(Utils.formatDate(new Date(),null));
        patientStatusDTO.setModifiedTimestamp(Utils.formatDate(new Date(),null));
        PatientStatus patientStatus = patientAdmitDAO.updatePatientAdmitRecord(patientAdmitMapper.toEntity(patientStatusDTO));
        return patientAdmitMapper.toDto(patientStatus);
    }

    /**
     * To fetch PatientStatus for given patientId and providerId
     * @param patientId
     * @param providerId
     * @return PatientStatus matching given patientId and ProviderId.
     */
    @Override
    public PatientStatusDTO getPatientAdmitDetail(String patientId, String providerId) {
        log.info("PatientAdmitServiceImpl#getPatientAdmitDetail");
        PatientStatus patientStatusRecord = patientAdmitDAO.getPatientAdmitRecord(patientId, providerId);
        return patientAdmitMapper.toDto(patientStatusRecord);
    }

    /**
     * To fetch list of PatientStatus for a particular patient.
     * @param patientId
     * @return List of all patientStatus matching given patientId.
     */
    @Override
    public List<PatientStatusDTO> getPatientAdmitByExp(String patientId) {
        log.info("PatientAdmitServiceImpl#getPatientAdmitByExp");
        List<PatientStatus> patientStatusByExp = patientAdmitDAO.getPatientAdmitByExp(patientId);
        return patientAdmitMapper.toDto(patientStatusByExp);
    }

}
