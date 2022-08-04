package gov.cms.acme.service.impl;

import gov.cms.acme.dto.PatientStatusResponseDTO;
import gov.cms.acme.dto.PatientStatusRequestDTO;
import gov.cms.acme.entity.PatientStatus;
import gov.cms.acme.utils.SecurityUtil;
import gov.cms.acme.utils.Utils;
import gov.cms.acme.dao.PatientStatusDAO;
import gov.cms.acme.dto.mapper.PatientStatusMapper;
import gov.cms.acme.service.PatientStatusService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
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
     * @param patientStatusResponseDTO
     * @return
     */
    @Override
    public String updatePatientStatus(PatientStatusResponseDTO patientStatusResponseDTO){
        log.info("PatientStatusServiceImpl#updatePatientStatus");
//      setting current datetime to statusUpdateDate and ModifiedTimestamp.
        patientStatusResponseDTO.setStatusUpdateDate(Utils.formatDate(new Date(),null));
        patientStatusResponseDTO.setModifiedTimestamp(Utils.formatDate(new Date(),null));
        return patientStatusDAO.updatePatientStatusRecord(patientStatusMapper.toEntity(patientStatusResponseDTO));
    }

    /**
     * To fetch PatientStatus for given patientId and providerId
     * @param patientId
     * @param providerId
     * @return PatientStatus matching given patientId and ProviderId.
     */
    @Override
    public PatientStatusResponseDTO getPatientStatusDetail(String patientId, String providerId) {
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
    public List<PatientStatusResponseDTO> getPatientStatusByExp(String patientId) {
        log.info("PatientStatusServiceImpl#getPatientStatusByExp");
        List<PatientStatus> patientStatusByExp = patientStatusDAO.getPatientStatusByExp(patientId);
        return patientStatusMapper.toDto(patientStatusByExp);
    }

    @Override
    public String updatePatientStatus(PatientStatusRequestDTO patientStatusDTO, String facilityId) {
        log.info("PatientStatusServiceImpl#updatePatientStatus params {} , patientStatusDTO {}",facilityId, patientStatusDTO);

        PatientStatus patientStatus=new PatientStatus();
        BeanUtils.copyProperties(patientStatusDTO,patientStatus);

        patientStatus.setStatus(patientStatusDTO.getStatus().toString());
        patientStatus.setDisasterType(patientStatusDTO.getDisasterType().toString());
        patientStatus.setProvNbr(facilityId);
        String currentTimestamp = Utils.formatDate(new Date(), null);
        patientStatus.setStatusUpdateDate(currentTimestamp);
        patientStatus.setModifiedTimestamp(currentTimestamp);
        patientStatus.setCreatedTimestamp(currentTimestamp);
        String username = SecurityUtil.getUsername();
        patientStatus.setModifiedBy(username);
        patientStatus.setCreatedBy(username);
        log.debug("patientStatus : {}",patientStatus);
        return patientStatusDAO.updatePatientStatusRecord(patientStatus);
    }

}
