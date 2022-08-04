package gov.cms.acme.service;


import gov.cms.acme.dao.PatientAdmitDAO;
import gov.cms.acme.dto.PatientStatusDTO;
import gov.cms.acme.dto.mapper.PatientAdmitMapper;
import gov.cms.acme.dto.mapper.PatientAdmitMapperImpl;
import gov.cms.acme.entity.AdmitStatus;
import gov.cms.acme.entity.DisasterType;
import gov.cms.acme.entity.PatientStatus;
import gov.cms.acme.service.impl.PatientAdmitServiceImpl;
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
@ContextConfiguration(classes = {PatientAdmitMapperImpl.class})
public class PatientAdmitServiceTest {

    @MockBean
    private PatientAdmitDAO patientAdmitDAO;

    @Autowired
    @SpyBean
    private PatientAdmitMapper patientAdmitMapper;

    private  PatientAdmitService patientAdmitService;

    private PatientStatusDTO patientStatusDTO;

    @Before
    public void init(){
        patientAdmitService=new PatientAdmitServiceImpl(patientAdmitDAO, patientAdmitMapper);
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
    public void updatePatientAdmitTest(){
        log.info("# updatePatientAdmitTest");
        PatientStatus patientStatus = patientAdmitMapper.toEntity(this.patientStatusDTO);
        when(patientAdmitDAO.updatePatientAdmitRecord(any(PatientStatus.class)))
                .thenReturn(patientStatus);
        PatientStatusDTO patientStatusDTO = patientAdmitService.updatePatientAdmit(this.patientStatusDTO);

        assertThat(patientStatusDTO).isNotNull();
        assertThat(patientStatusDTO.getPatId() ).isEqualTo(this.patientStatusDTO.getPatId());
        assertThat(patientStatusDTO.getProvNbr()).isEqualTo(this.patientStatusDTO.getProvNbr());

        verify(patientAdmitDAO,times(1)).updatePatientAdmitRecord(any(PatientStatus.class));
        verify(patientAdmitMapper,times(1)).toEntity(any(PatientStatusDTO.class));

    }

    @Test
    public void getPatientAdmitDetailTest(){
        log.info("# getPatientAdmitDetailTest");
        PatientStatus patientStatus = patientAdmitMapper.toEntity(patientStatusDTO);
        when(patientAdmitDAO.getPatientAdmitRecord(anyString(),anyString())).thenReturn(patientStatus);

        PatientStatusDTO patientAdmitDetail = patientAdmitService.getPatientAdmitDetail(patientStatusDTO.getPatId(), patientStatusDTO.getProvNbr());

        assertThat(patientAdmitDetail).isNotNull();
        assertThat(patientAdmitDetail.getPatId()).isNotBlank();
        assertThat(patientAdmitDetail.getProvNbr()).isNotBlank();
        assertThat(patientAdmitDetail).isEqualTo(patientStatusDTO);
        assertThat(patientAdmitDetail.getPatId()).isEqualTo(patientStatusDTO.getPatId());
        assertThat(patientAdmitDetail.getProvNbr()).isEqualTo(patientStatusDTO.getProvNbr());

        verify(patientAdmitDAO,times(1)).getPatientAdmitRecord(anyString(),anyString());
        verify(patientAdmitMapper,times(1)).toDto(any(PatientStatus.class));

    }

}
