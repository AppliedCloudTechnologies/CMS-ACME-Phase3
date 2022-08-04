package gov.cms.acme.dto.mapper;

import gov.cms.acme.dto.PatientStatusResponseDTO;
import gov.cms.acme.entity.PatientStatus;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PatientStatusMapper extends EntityMapper<PatientStatus, PatientStatusResponseDTO> {

}
