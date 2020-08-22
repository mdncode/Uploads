@sReserve
Feature: GCP Soft Reservation API for reserve endpoints
   Background: Setup
   * url 'https://www-reg2.cvs.com/'
   * def validReservation = read('classpath:data/gcpSoftReserve/reservationValid.json')
   * def cancelReservation = read('classpath:data/gcpSoftReserve/cancelReservation.json')
   * def confirmReservation = read('classpath:data/gcpSoftReserve/confirmReservation.json')
   * def utcTimeNow = Java.type('utils.GetUTCTime')
   * def getCSTDate = utcTimeNow.GetUTCTimeForCST()
   * def getPSTDate = utcTimeNow.GetUTCTimeForPST()
   * print getCSTDate
   * print getPSTDate

   Scenario Outline: Make a reservation and cancel reservation
   * def reservationPayLoad = validReservation.tc001_validReservation.request_Value
   * def reservationHeader = validReservation.tc001_validReservation.header_value.apiKey
   * copy cancelReservationPayLoad = cancelReservation
   * copy newPayloadVisitDateTime = reservationPayLoad
   * set newPayloadVisitDateTime.reservation.visitDateTime =  getCSTDate
   * def getHourAndMin = utcTimeNow.GetHourAndMinute(getCSTDate)
   * def addDays = utcTimeNow.GetDate(0)
   
    Given path 'mctimeslot/node/scheduler/v2/clinics/reservation'
    * set newPayloadVisitDateTime.reservation.clinicId =  <clinicId>
    * set newPayloadVisitDateTime.reservation.timeZone =  <timeZone>
    And request  newPayloadVisitDateTime
    And header x-api-key = reservationHeader
    When method post
    Then def reservationCode = response.details.reservationCode
    Then print reservationCode
    Then print getHourAndMin
    Then print addDays
    Then status 200
    Then response.header.statusCode = "0000"
    Then response.header.statusTitle = "Sucess"
    Then response.header.statusDescription = "Sucess"

    Given path 'mctimeslot/node/scheduler/v2/clinics/reservedslots'
    And param clinicId = newPayloadVisitDateTime.reservation.clinicId
    And param visitStartDate = utcTimeNow.GetDate(0) 
    And param visitEndDate = utcTimeNow.GetDate(1) 
    When method get
    Then status 200
    #Then match response.details.reservedslots contains getHourAndMin

    * set cancelReservationPayLoad.reservation.reservationCode = reservationCode
    
    Given path 'mctimeslot/node/scheduler/v2/clinics/reservation/cancel'
    And request cancelReservationPayLoad
    When method post
    Then status 200
    Then response.header.statusCode = "0000"
    Then response.header.statusTitle = "Sucess"
    Then response.header.statusDescription = "Sucess"

    Examples: 
|	clinicId	|	timeZone	| clinidParamId|
|	"3460"	|	"MST"	| 3460 |
|	"3191"	|	"MDT"	| 3191 |
|	"3011"	|	"CDT"	| 3011 |
|	"3254"	|	"CDT"	| 3254 |
|	"3371"	|	"EDT"	| 3371 |
|	"3477"	|	"EDT"	| 3477 |
|	"3038"	|	"EDT"	| 3038 |
|	"2994"	|	"EDT"	| 2994 |
|	"2949"	|	"PDT"	| 2949 |
|	"2980"	|	"HDT"	| 2980 |

Scenario Outline: Make a reservation and confirm reservation
   * def reservationPayLoad = validReservation.tc001_validReservation.request_Value
   * def reservationHeader = validReservation.tc001_validReservation.header_value.apiKey
   * copy cancelReservationPayLoad = cancelReservation
   * copy newPayloadVisitDateTime = reservationPayLoad
   * copy confirmReservationPayLoad = confirmReservation
   * set newPayloadVisitDateTime.reservation.visitDateTime =  getCSTDate


Given path 'mctimeslot/node/scheduler/v2/clinics/reservation'
    * set newPayloadVisitDateTime.reservation.clinicId =  <clinicId>
    * set newPayloadVisitDateTime.reservation.timeZone =  <timeZone>
    And request  newPayloadVisitDateTime
    And header x-api-key = reservationHeader
    When method post
    Then def reservationCode = response.details.reservationCode
    Then print reservationCode
    Then status 200
    Then response.header.statusCode = "0000"
    Then response.header.statusTitle = "Sucess"
    Then response.header.statusDescription = "Sucess"

 
    
    Given path 'mctimeslot/node/scheduler/v2/clinics/reservation'
   * set confirmReservationPayLoad.reservation.clinicId =  <clinicId>
   * set confirmReservationPayLoad.reservation.reservationCode = reservationCode
    And request confirmReservationPayLoad
    When method patch
    Then status 200
    Then response.header.statusCode = "0000"
    Then response.header.statusTitle = "Sucess"
    Then response.header.statusDescription = "Sucess"

    Examples: 
|	clinicId	|	timeZone	|
|	"3460"	|	"MST"	|
|	"3191"	|	"MDT"	|
|	"3011"	|	"CDT"	|
|	"3254"	|	"CDT"	|
|	"3371"	|	"EDT"	|
|	"3477"	|	"EDT"	|
|	"3038"	|	"EDT"	|
|	"2994"	|	"EDT"	|
|	"2949"	|	"PDT"	|
|	"2980"	|	"HDT"	|

   