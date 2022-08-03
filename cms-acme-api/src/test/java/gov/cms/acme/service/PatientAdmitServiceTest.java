package gov.cms.acme.service;


import gov.cms.acme.dao.PatientAdmitDAO;
import gov.cms.acme.dto.PatientAdmitDTO;
import gov.cms.acme.dto.mapper.PatientAdmitMapper;
import gov.cms.acme.dto.mapper.PatientAdmitMapperImpl;
import gov.cms.acme.entity.AdmitStatus;
import gov.cms.acme.entity.DisasterType;
import gov.cms.acme.entity.PatientAdmit;
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

    private PatientAdmitDTO patientAdmitDTO;

    @Before
    public void init(){
        patientAdmitService=new PatientAdmitServiceImpl(patientAdmitDAO, patientAdmitMapper);
        patientAdmitDTO=new PatientAdmitDTO();
        patientAdmitDTO.setPatId("1111");
        patientAdmitDTO.setProvId("2222");
        patientAdmitDTO.setAdmitDate(new Date().toString());
        patientAdmitDTO.setNotes("This is Note.");
        patientAdmitDTO.setStatus(AdmitStatus.DECEASED);
        patientAdmitDTO.setDisasterType(DisasterType.HURRICANE);
        patientAdmitDTO.setStatusUpdateDate(new Date().toString());

    }

    @Test
    public void updatePatientAdmitTest(){
        log.info("# updatePatientAdmitTest");
        PatientAdmit patientAdmit = patientAdmitMapper.toEntity(patientAdmitDTO);
        when(patientAdmitDAO.updatePatientAdmitRecord(any(PatientAdmit.class)))
                .thenReturn(patientAdmit);
        PatientAdmitDTO patientAdmitDTO = patientAdmitService.updatePatientAdmit(this.patientAdmitDTO);

        assertThat(patientAdmitDTO).isNotNull();
        assertThat(patientAdmitDTO.getPatId() ).isEqualTo(this.patientAdmitDTO.getPatId());
        assertThat(patientAdmitDTO.getProvId()).isEqualTo(this.patientAdmitDTO.getProvId());

        verify(patientAdmitDAO,times(1)).updatePatientAdmitRecord(any(PatientAdmit.class));
        verify(patientAdmitMapper,times(1)).toEntity(any(PatientAdmitDTO.class));

    }

    @Test
    public void getPatientAdmitDetailTest(){
        log.info("# getPatientAdmitDetailTest");
        PatientAdmit patientAdmit = patientAdmitMapper.toEntity(patientAdmitDTO);
        when(patientAdmitDAO.getPatientAdmitRecord(anyString(),anyString())).thenReturn(patientAdmit);

        PatientAdmitDTO patientAdmitDetail = patientAdmitService.getPatientAdmitDetail(patientAdmitDTO.getPatId(), patientAdmitDTO.getProvId());

        assertThat(patientAdmitDetail).isNotNull();
        assertThat(patientAdmitDetail.getPatId()).isNotBlank();
        assertThat(patientAdmitDetail.getProvId()).isNotBlank();
        assertThat(patientAdmitDetail).isEqualTo(patientAdmitDTO);
        assertThat(patientAdmitDetail.getPatId()).isEqualTo(patientAdmitDTO.getPatId());
        assertThat(patientAdmitDetail.getProvId()).isEqualTo(patientAdmitDTO.getProvId());

        verify(patientAdmitDAO,times(1)).getPatientAdmitRecord(anyString(),anyString());
        verify(patientAdmitMapper,times(1)).toDto(any(PatientAdmit.class));

    }

}
