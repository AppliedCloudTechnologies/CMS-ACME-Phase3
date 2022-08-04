package gov.cms.acme.service;


import gov.cms.acme.dao.PatientStatusDAO;
import gov.cms.acme.dto.PatientStatusDTO;
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

    private PatientStatusDTO patientStatusDTO;

    @Before
    public void init(){
        patientStatusService =new PatientStatusServiceImpl(patientStatusDAO, patientStatusMapper);
        patientStatusDTO =new PatientStatusDTO();
        patientStatusDTO.setPatId("1111");
        patientStatusDTO.setProvNbr("2222");
        patientStatusDTO.setAdmitDate(new Date().toString());
        patientStatusDTO.setNotes("This is Note.");
        patientStatusDTO.setStatus(AdmitStatus.DECEASED);
        patientStatusDTO.setDisasterType(DisasterType.HURRICANE);
        patientStatusDTO.setStatusUpdateDate(new Date().toString());

    }

    @Test
    public void updatePatientStatusTest(){
        log.info("# updatePatientStatusTest");
        PatientStatus patientStatus = patientStatusMapper.toEntity(this.patientStatusDTO);
        String status="PatientStatus saved successfully!";
        when(patientStatusDAO.updatePatientStatusRecord(any(PatientStatus.class)))
                .thenReturn(status);
        String patientStatusResult = patientStatusService.updatePatientStatus(this.patientStatusDTO);

        assertThat(patientStatusResult).isNotNull();
        assertThat(patientStatusResult).isNotBlank();
        assertThat(patientStatusResult).isEqualTo(status);

        verify(patientStatusDAO,times(1)).updatePatientStatusRecord(any(PatientStatus.class));
        verify(patientStatusMapper,times(1)).toEntity(any(PatientStatusDTO.class));

    }

    @Test
    public void getPatientStatusDetailTest(){
        log.info("# getPatientStatusDetailTest");
        PatientStatus patientStatus = patientStatusMapper.toEntity(patientStatusDTO);
        when(patientStatusDAO.getPatientStatusRecord(anyString(),anyString())).thenReturn(patientStatus);

        PatientStatusDTO patientStatusDetail = patientStatusService.getPatientStatusDetail(patientStatusDTO.getPatId(), patientStatusDTO.getProvNbr());

        assertThat(patientStatusDetail).isNotNull();
        assertThat(patientStatusDetail.getPatId()).isNotBlank();
        assertThat(patientStatusDetail.getProvNbr()).isNotBlank();
        assertThat(patientStatusDetail).isEqualTo(patientStatusDTO);
        assertThat(patientStatusDetail.getPatId()).isEqualTo(patientStatusDTO.getPatId());
        assertThat(patientStatusDetail.getProvNbr()).isEqualTo(patientStatusDTO.getProvNbr());

        verify(patientStatusDAO,times(1)).getPatientStatusRecord(anyString(),anyString());
        verify(patientStatusMapper,times(1)).toDto(any(PatientStatus.class));

    }

}
