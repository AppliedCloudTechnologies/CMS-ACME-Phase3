package gov.cms.acme.utils;


import gov.cms.acme.dto.CmsResponse;
import lombok.extern.slf4j.Slf4j;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Objects;

@Slf4j
public class Utils {

    public static <T> CmsResponse<T> toResponse(T data, String code, String description){
//        Setting response using given parameters.
        CmsResponse.CmsResponseStatus status=new CmsResponse.CmsResponseStatus(description,code);
        return new CmsResponse<>(data,status);
    }

    public static String formatDate(Date date, String format){
        log.info("Utils#formatDate Date: {}, format: {}",date,format);
//        check if format is null or blank then set default as yyyy-MM-dd HH:mm:ss
        format= Objects.isNull(format)|| format.isBlank()? "yyyy-MM-dd HH:mm:ss" :format;
        log.info("Utils#formatDate format: {}",date,format);
//        format date as per given format value.
        SimpleDateFormat formatter = new SimpleDateFormat(format);
        String strDate = formatter.format(date);
        log.info("Formatted Date: {}",strDate);
        return strDate;
    }

}
