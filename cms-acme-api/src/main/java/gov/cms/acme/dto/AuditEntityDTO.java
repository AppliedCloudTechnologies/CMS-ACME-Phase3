package gov.cms.acme.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;

@Data
public class AuditEntityDTO {

    private String createdBy;
    private Date createdAt;
    private String updatedBy;
    private Date updatedAt;

}
