package gov.cms.acme.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class AuditEntityDTO {

    @JsonProperty(value = "created_by")
    private String createdBy;
    @JsonProperty(value = "created_timestamp")
    private String createdTimestamp;
    @JsonProperty(value = "modified_by")
    private String modifiedBy;
    @JsonProperty(value = "modified_timestamp")
    private String modifiedTimestamp;

}
