package gov.cms.acme.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CmsResponse<T> {

    T data;
    String status;
    boolean isError;

}
