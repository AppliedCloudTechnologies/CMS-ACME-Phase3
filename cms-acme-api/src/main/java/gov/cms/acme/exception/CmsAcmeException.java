package gov.cms.acme.exception;

import lombok.Data;


public class CmsAcmeException extends RuntimeException{

    private String errorCode;
    private String errorResponse;

    public CmsAcmeException(){
        super();
    }

    public CmsAcmeException(String message){
        super(message);
    }

    public CmsAcmeException(String message, String errorCode, String errorResponse){
        super(message);
        this.errorCode=errorCode;
        this.errorResponse=errorResponse;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public String getErrorResponse() {
        return errorResponse;
    }
}
