package gov.cms.acme.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.FORBIDDEN)
public class CmsAccessDeniedException extends CmsAcmeException{
    public CmsAccessDeniedException(String message) {
        super(message);
    }
}
