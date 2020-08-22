package utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class getCurrentDate {
    public static String getDate(){
        Date date = new Date();  
        SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");  
        String strDate= formatter.format(date);  
        return strDate; 
    }
}