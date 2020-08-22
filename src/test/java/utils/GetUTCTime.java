package utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;

public class GetUTCTime {

    private static final String DATE_FORMAT = "dd-M-yyyy hh:mm:ss a";
    // public static Date GetCurrentUTCTime() {
    // //OffsetDateTime now = OffsetDateTime.now(ZoneOffset.UTC);
    // Calendar cal = Calendar.getInstance();
    // cal.add(Calendar.HOUR_OF_DAY, +1);
    // Date abc = cal.getTime();
    // // OffsetDateTime now = OffsetDateTime.abc(ZoneOffset.UTC);

    // }

    public static String GetUTCTimeForCST() {
        LocalDateTime dateInString = OffsetDateTime.now(ZoneOffset.UTC).toLocalDateTime();
        System.out.println(dateInString);
        LocalDateTime ldt = dateInString;
        ZoneId centralZoneId = ZoneId.of("America/Chicago");

        ZonedDateTime chicagoTime = ldt.atZone(centralZoneId);

        ZoneId easternZoneId = ZoneId.of("America/New_York");

        ZonedDateTime nyDateTime = chicagoTime.withZoneSameInstant(easternZoneId);
        OffsetDateTime offsetdate = nyDateTime.toOffsetDateTime();
        OffsetDateTime offsetdateplusone = offsetdate.plusHours(0);
        String dateString = offsetdateplusone.toString();
        return dateString;
    }

    public static OffsetDateTime GetUTCTimeForPST() {
        LocalDateTime dateInString = OffsetDateTime.now(ZoneOffset.UTC).toLocalDateTime();
        System.out.println(dateInString);
        LocalDateTime ldt = dateInString;
        ZoneId pstZoneId = ZoneId.of("America/Los_Angeles");

        ZonedDateTime laTime = ldt.atZone(pstZoneId);

        ZoneId easternZoneId = ZoneId.of("America/New_York");

        ZonedDateTime nyDateTime = laTime.withZoneSameInstant(easternZoneId);
        OffsetDateTime offsetdate = nyDateTime.toOffsetDateTime();
        OffsetDateTime offsetdateplusone = offsetdate.plusHours(1);
        return offsetdateplusone;
    }

    public static String GetHourAndMinute(String utcTIme) throws ParseException {

        OffsetDateTime date1 = OffsetDateTime.parse(utcTIme);
        int a = date1.getHour();
        int b = date1.getMinute();
        // System.out.println(utcTIme);
        String hour = (a + ":" + b);
        SimpleDateFormat twentyfourhourformat = new SimpleDateFormat("hh:mm");
        Date date = null;
        String result;
        String formatTwelve;
        date = twentyfourhourformat.parse(hour);

        formatTwelve = twentyfourhourformat.format(date);

        if (formatTwelve.equals(hour)) {
            result = formatTwelve + " AM";
        } else {
            result = formatTwelve + " PM";
        }
        // System.out.println(hour);
        return result;
    }
    public static String GetDate(int addDays){
        LocalDate dt = LocalDate.now().plusDays(addDays);
        String getDate = dt.toString();
        return getDate;

    }
}