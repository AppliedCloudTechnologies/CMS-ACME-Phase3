package gov.cms.acme.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CmsResponse<T> {


    T data;
    CmsResponseStatus status;

    @Data
    @AllArgsConstructor
    public static class CmsResponseStatus {
        private String description;
        private String code;
    }
}
