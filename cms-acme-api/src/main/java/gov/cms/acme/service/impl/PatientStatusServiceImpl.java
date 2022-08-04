package gov.cms.acme.service.impl;

import gov.cms.acme.dto.PatientStatusDTO;
import gov.cms.acme.entity.PatientStatus;
import gov.cms.acme.utils.Utils;
import gov.cms.acme.dao.PatientStatusDAO;
import gov.cms.acme.dto.mapper.PatientStatusMapper;
import gov.cms.acme.service.PatientStatusService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;


@Service
@Slf4j
@RequiredArgsConstructor
public class PatientStatusServiceImpl implements PatientStatusService {

    private final PatientStatusDAO patientStatusDAO;
    private final PatientStatusMapper patientStatusMapper;

    /**
     * to update patientStatus.
     * @param patientStatusDTO
     * @return
     */
    @Override
    public String updatePatientStatus(PatientStatusDTO patientStatusDTO){
        log.info("PatientStatusServiceImpl#updatePatientStatus");
//      setting current datetime to statusUpdateDate and ModifiedTimestamp.
        patientStatusDTO.setStatusUpdateDate(Utils.formatDate(new Date(),null));
        patientStatusDTO.setModifiedTimestamp(Utils.formatDate(new Date(),null));
        return patientStatusDAO.updatePatientStatusRecord(patientStatusMapper.toEntity(patientStatusDTO));
    }

    /**
     * To fetch PatientStatus for given patientId and providerId
     * @param patientId
     * @param providerId
     * @return PatientStatus matching given patientId and ProviderId.
     */
    @Override
    public PatientStatusDTO getPatientStatusDetail(String patientId, String providerId) {
        log.info("PatientStatusServiceImpl#getPatientStatusDetail");
        PatientStatus patientStatusRecord = patientStatusDAO.getPatientStatusRecord(patientId, providerId);
        return patientStatusMapper.toDto(patientStatusRecord);
    }

    /**
     * To fetch list of PatientStatus for a particular patient.
     * @param patientId
     * @return List of all patientStatus matching given patientId.
     */
    @Override
    public List<PatientStatusDTO> getPatientStatusByExp(String patientId) {
        log.info("PatientStatusServiceImpl#getPatientStatusByExp");
        List<PatientStatus> patientStatusByExp = patientStatusDAO.getPatientStatusByExp(patientId);
        return patientStatusMapper.toDto(patientStatusByExp);
    }

}
