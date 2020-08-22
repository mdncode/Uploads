@sReserveA
Feature: GCP Soft Reservation API for reserve endpoints
   Background: Setup
   * url 'https://www-reg2.cvs.com/'
   * def getAvailableSlotsJSON = read('classpath:data/gcpSoftReserve/getAvailableSlots.json')
   * def validReservation = read('classpath:data/gcpSoftReserve/reservationValid.json')
   * def cancelReservation = read('classpath:data/gcpSoftReserve/cancelReservation.json')
   * def confirmReservation = read('classpath:data/gcpSoftReserve/confirmReservation.json')
   * def reservationRequest = read('classpath:data/gcpSoftReserve/reservationRequest.json')
   * def reservationResponse = read('classpath:data/gcpSoftReserve/reservationResponse.json')

   * def utcTimeNow = Java.type('utils.GetUTCTime')
   * def getCSTDate = utcTimeNow.GetUTCTimeForCST()
   * def getPSTDate = utcTimeNow.GetUTCTimeForPST()
   * print getCSTDate
   * print getPSTDate   
   
   * def getLocalDateUtils = Java.type('utils.getCurrentDate')
   * def getCurrentDate = getLocalDateUtils.getDate()
   * print getCurrentDate
        
    * def cancelReservation = cancelReservation
    * copy cancelReservation = cancelReservation       
        
    * def reservation = reservationRequest
    * copy reservation = reservation
    Given path '/mctimeslot/node/scheduler/v2/clinics/reservation'
    Given request reservation

# ##########################################################################
#     Scenario: error 5007 (past date)
#         When method post
#         Then status 400
#         Then match response == reservationResponse.error_5007

# ##########################################################################
#     Scenario Outline: error 5009 (missing parameters)
#         * set reservation.reservation.clinicId = <clinicId>
#         * set reservation.reservation.timeZone = <timeZone>
#         * set reservation.reservation.operationId = <operationId>
#         * set reservation.reservation.visitDateTime = <visitDateTime>

#         When method post
#         Then status 400
#         Then match response == reservationResponse.error_5009
#         Examples: 
#             |clinicId	|timeZone	| operationId|visitDateTime|
#             |""	        |"CDT"	    |"2"        |"2020-06-17T13:20:00.000Z"|
#             |"3254"	    |""	        |"2"        |"2020-06-17T13:20:00.000Z"|
#             |"3254"	    |"CDT"	    |""         |"2020-06-17T13:20:00.000Z"|
#             |"3254"	    |"EDT"	    |"2"        |""                         |

# ##########################################################################
#     Scenario Outline: error 5004 (Invalid Operation ID)
#         * set reservation.reservation.operationId = <operationId>
#         When method post
#         Then status 400
#         Then match response == reservationResponse.error_5004
#         Examples: 
#             | operationId|
#             |"2X"         |

##########################################################################
    Scenario Outline: reservation success
# make reservation
        * set reservation.reservation.clinicId = <clinicId>
        * set reservation.reservation.timeZone = <timeZone>
        * set reservation.reservation.operationId = <operationId>
        * set reservation.reservation.visitDateTime = <visitDateTime>

        When method post
        Then status 200
        Then response.header.statusCode = "0000"
        Then response.header.statusTitle = "Sucess"

# cancel reservation   
        * def reservationCode = response.details.reservationCode
        * set cancelReservation.reservation.reservationCode = reservationCode         
        * set cancelReservation.reservation.clinicId = <clinicId>
        Given path 'mctimeslot/node/scheduler/v2/clinics/reservation/cancel'
        And request cancelReservation
        When method post
        Then status 200
        Then response.header.statusCode = "0000"
        Then response.header.statusTitle = "Sucess"      

        Examples: 
            |clinicId	|timeZone	| operationId|visitDateTime|
            |"3254"	    |"CDT"	    |"2"        |"2020-10-14T10:00:00.000Z"|
            |"3254"	    |"CDTABC"	    |"2"        |"2020-10-14T10:00:00.000Z"|
            # |"3"	    |"CDT"	    |"2"        |"2020-10-17T11:00:00.000Z"|
            # |"3254ABCD"	|"CDT"	    |"2"        |"2020-10-17T11:00:00.000Z"|
            # # |"3254"	    |"CDTABC"	|"2"        |"2020-10-17T11:00:00.000Z"|
            # |"3254"	    |"CDT"	    |"2"        |"2020-10-17T11:00:00.000Z9999999"|
            # |"3254"	    |"CDT"	    |"2"        |"2020-10-17"|





#    Scenario Outline: Make reservation -> cancel reservation
#    * def reservationPayLoad = validReservation.tc001_validReservation.request_Value
#    * def reservationHeader = validReservation.tc001_validReservation.header_value.apiKey
#    * copy cancelReservationPayLoad = cancelReservation
#    * copy newPayloadVisitDateTime = reservationPayLoad
#    * set newPayloadVisitDateTime.reservation.visitDateTime =  getCSTDate
#    * def getHourAndMin = utcTimeNow.GetHourAndMinute(getCSTDate)
#    * def addDays = utcTimeNow.GetDate(0)   
   
#    * def getAvailableSlotsPayLoad = getAvailableSlotsJSON.getAvailableSlots
#    * copy newgetAvailableSlotsPayLoad = getAvailableSlotsPayLoad
#    * set newgetAvailableSlotsPayLoad.details[0].startDate =  getCurrentDate
#    * set newgetAvailableSlotsPayLoad.details[0].endDate =  getCurrentDate
#    * set newgetAvailableSlotsPayLoad.details[0].clinicId =  <clinicId>
   

# # get Available slots
#     Given path '/RETAGPV1/scheduler/V3/getAvailableSlots'
#     And request newgetAvailableSlotsPayLoad
#     When method post
#     Then status 200

# # make reservation   
#     Given path 'mctimeslot/node/scheduler/v2/clinics/reservation'
#     * set newPayloadVisitDateTime.reservation.clinicId =  <clinicId>
#     * set newPayloadVisitDateTime.reservation.timeZone =  <timeZone>
#     And request  newPayloadVisitDateTime
#     And header x-api-key = reservationHeader
#     When method post
#     Then def reservationCode = response.details.reservationCode
#     Then print reservationCode
#     Then print getHourAndMin
#     Then print addDays
#     Then status 200
#     Then response.header.statusCode = "0000"
#     Then response.header.statusTitle = "Sucess"
#     Then response.header.statusDescription = "Sucess"

# # getReservedslots
#     Given path 'mctimeslot/node/scheduler/v2/clinics/reservedslots'
#     And param clinicId = newPayloadVisitDateTime.reservation.clinicId
#     And param visitStartDate = utcTimeNow.GetDate(0) 
#     And param visitEndDate = utcTimeNow.GetDate(1) 
#     When method get
#     Then status 200
#     #Then match response.details.reservedslots contains getHourAndMin

#     * set cancelReservationPayLoad.reservation.reservationCode = reservationCode
    
# # # cancel reservation   
# #     Given path 'mctimeslot/node/scheduler/v2/clinics/reservation/cancel'
# #     And request cancelReservationPayLoad
# #     When method post
# #     Then status 200
# #     Then response.header.statusCode = "0000"
# #     Then response.header.statusTitle = "Sucess"
# #     Then response.header.statusDescription = "Sucess"

#     Examples: 
#     |	clinicId	|	timeZone	| clinidParamId|
#     |	"3254"	    |	"CDT"	    | 3254 |
#     # |	"3011"	    |	"CDT"	    | 3011 |
#     # |	"3460"	    |	"MST"	    | 3460 |
#     # |	"3191"	    |	"MDT"	    | 3191 |
#     # |	"3371"	    |	"EDT"	    | 3371 |
#     # |	"3477"	    |	"EDT"	    | 3477 |
#     # |	"3038"	    |	"EDT"	    | 3038 |
#     # |	"2994"	    |	"EDT"	    | 2994 |
#     # |	"2949"	    |	"PDT"	    | 2949 |
#     # |	"2980"	    |	"HDT"	    | 2980 |

# # Scenario Outline: Make a reservation and confirm reservation
# #    * def reservationPayLoad = validReservation.tc001_validReservation.request_Value
# #    * def reservationHeader = validReservation.tc001_validReservation.header_value.apiKey
# #    * copy cancelReservationPayLoad = cancelReservation
# #    * copy newPayloadVisitDateTime = reservationPayLoad
# #    * copy confirmReservationPayLoad = confirmReservation
# #    * set newPayloadVisitDateTime.reservation.visitDateTime =  getCSTDate


# # Given path 'mctimeslot/node/scheduler/v2/clinics/reservation'
# #     * set newPayloadVisitDateTime.reservation.clinicId =  <clinicId>
# #     * set newPayloadVisitDateTime.reservation.timeZone =  <timeZone>
# #     And request  newPayloadVisitDateTime
# #     And header x-api-key = reservationHeader
# #     When method post
# #     Then def reservationCode = response.details.reservationCode
# #     Then print reservationCode
# #     Then status 200
# #     Then response.header.statusCode = "0000"
# #     Then response.header.statusTitle = "Sucess"
# #     Then response.header.statusDescription = "Sucess"

 
    
# #     Given path 'mctimeslot/node/scheduler/v2/clinics/reservation'
# #    * set confirmReservationPayLoad.reservation.clinicId =  <clinicId>
# #    * set confirmReservationPayLoad.reservation.reservationCode = reservationCode
# #     And request confirmReservationPayLoad
# #     When method patch
# #     Then status 200
# #     Then response.header.statusCode = "0000"
# #     Then response.header.statusTitle = "Sucess"
# #     Then response.header.statusDescription = "Sucess"

# #     Examples: 
# # |	clinicId	|	timeZone	|
# # |	"3460"	|	"MST"	|
# # |	"3191"	|	"MDT"	|
# # |	"3011"	|	"CDT"	|
# # |	"3254"	|	"CDT"	|
# # |	"3371"	|	"EDT"	|
# # |	"3477"	|	"EDT"	|
# # |	"3038"	|	"EDT"	|
# # |	"2994"	|	"EDT"	|
# # |	"2949"	|	"PDT"	|
# # |	"2980"	|	"HDT"	|

   