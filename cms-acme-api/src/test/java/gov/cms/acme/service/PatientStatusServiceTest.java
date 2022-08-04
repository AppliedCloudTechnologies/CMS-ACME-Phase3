package gov.cms.acme.service;


import gov.cms.acme.dao.PatientStatusDAO;
import gov.cms.acme.dto.PatientStatusResponseDTO;
import gov.cms.acme.dto.mapper.PatientStatusMapper;
import gov.cms.acme.dto.mapper.PatientStatusMapperImpl;
import gov.cms.acme.entity.AdmitStatus;
import gov.cms.acme.entity.DisasterType;
import gov.cms.acme.entity.PatientStatus;
import gov.cms.acme.service.impl.PatientStatusServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.boot.test.mock.mockito.SpyBean;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Date;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@Slf4j
@RunWith(SpringRunner.class)
@ContextConfiguration(classes = {PatientStatusMapperImpl.class})
public class PatientStatusServiceTest {

    @MockBean
    private PatientStatusDAO patientStatusDAO;

    @Autowired
    @SpyBean
    private PatientStatusMapper patientStatusMapper;

    private PatientStatusService patientStatusService;

    private PatientStatusResponseDTO patientStatusResponseDTO;

    @Before
    public void init(){
        patientStatusService =new PatientStatusServiceImpl(patientStatusDAO, patientStatusMapper);
        patientStatusResponseDTO =new PatientStatusResponseDTO();
        patientStatusResponseDTO.setPatId("1111");
        patientStatusResponseDTO.setProvNbr("2222");
        patientStatusResponseDTO.setNotes("This is Note.");
        patientStatusResponseDTO.setStatus(AdmitStatus.DECEASED);
        patientStatusResponseDTO.setDisasterType(DisasterType.HURRICANE);
        patientStatusResponseDTO.setStatusUpdateDate(new Date().toString());

    }

    @Test
    public void updatePatientStatusTest(){
        log.info("# updatePatientStatusTest");
        PatientStatus patientStatus = patientStatusMapper.toEntity(this.patientStatusResponseDTO);
        String status="PatientStatus saved successfully!";
        when(patientStatusDAO.updatePatientStatusRecord(any(PatientStatus.class)))
                .thenReturn(status);
        String patientStatusResult = patientStatusService.updatePatientStatus(this.patientStatusResponseDTO);

        assertThat(patientStatusResult).isNotNull();
        assertThat(patientStatusResult).isNotBlank();
        assertThat(patientStatusResult).isEqualTo(status);

        verify(patientStatusDAO,times(1)).updatePatientStatusRecord(any(PatientStatus.class));
        verify(patientStatusMapper,times(1)).toEntity(any(PatientStatusResponseDTO.class));

    }

    @Test
    public void getPatientStatusDetailTest(){
        log.info("# getPatientStatusDetailTest");
        PatientStatus patientStatus = patientStatusMapper.toEntity(patientStatusResponseDTO);
        when(patientStatusDAO.getPatientStatusRecord(anyString(),anyString())).thenReturn(patientStatus);

        PatientStatusResponseDTO patientStatusDetail = patientStatusService.getPatientStatusDetail(patientStatusResponseDTO.getPatId(), patientStatusResponseDTO.getProvNbr());

        assertThat(patientStatusDetail).isNotNull();
        assertThat(patientStatusDetail.getPatId()).isNotBlank();
        assertThat(patientStatusDetail.getProvNbr()).isNotBlank();
        assertThat(patientStatusDetail).isEqualTo(patientStatusResponseDTO);
        assertThat(patientStatusDetail.getPatId()).isEqualTo(patientStatusResponseDTO.getPatId());
        assertThat(patientStatusDetail.getProvNbr()).isEqualTo(patientStatusResponseDTO.getProvNbr());

        verify(patientStatusDAO,times(1)).getPatientStatusRecord(anyString(),anyString());
        verify(patientStatusMapper,times(1)).toDto(any(PatientStatus.class));

    }

}
