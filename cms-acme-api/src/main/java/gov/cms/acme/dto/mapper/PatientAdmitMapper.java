package gov.cms.acme.dto.mapper;

import gov.cms.acme.dto.PatientAdmitDTO;
import gov.cms.acme.entity.PatientAdmit;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PatientAdmitMapper extends EntityMapper<PatientAdmit, PatientAdmitDTO> {

}
