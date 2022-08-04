package gov.cms.acme.dto.mapper;

import gov.cms.acme.dto.PatientStatusDTO;
import gov.cms.acme.entity.PatientStatus;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PatientAdmitMapper extends EntityMapper<PatientStatus, PatientStatusDTO> {

}
