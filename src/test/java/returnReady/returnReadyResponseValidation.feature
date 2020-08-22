@returnReadyResponseValidation
Feature: Return Eligibility API for apigee endpoints
    Background: Setup
        * url 'https://www-reg2.cvs.com/'
        * def eligibilityData = read('classpath:data/returnReady/returnReady-eligibility.json')
        * def eligibilityPayLoad = eligibilityData.TC001_returnready.requestPayLoad
        * def apikeyHeader = eligibilityData.TC001_returnready.headers.apiKey
        Given path 'mcapi/returnready/v1/covid-eligibility'
        Given header x-api-key = apikeyHeader

##########################################################################   
    Scenario Outline: Success 200 0000
        When request 
            """
                {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
            """
        When method post
        Then status 200
        Then match response.statusCode == "0000"
        Then match response.statusDescription == "Success"
        Then match response.companyCode == "592308"
        Examples:
|	zip		|gender	|	id		|		DOB		    |
|	"43311"	|	"M"	|	"100.1"	|	"1990-01-01"	|
|	"43311"	|	"F"	|	"101-1"	|	"1990-02-01"	|
|	"43311"	|	"M"	|	"102"	|	"1990-03-01"	|
|	"43311"	|	"F"	|	"103"	|	"1990-04-01"	|
|	"43311"	|	"M"	|	"104"	|	"1990-05-01"	|
|	"43311"	|	"M"	|	"105"	|	"1990-01-01"	|
|	"43311"	|	"F"	|	"106"	|	"1990-02-01"	|
|	"43311"	|	"M"	|	"107"	|	"1990-03-01"	|
|	"43311"	|	"F"	|	"108"	|	"1990-04-01"	|
|	"43311"	|	"M"	|	"109"	|	"1990-05-01"	|
|	"43311"	|	"M"	|	"110"	|	"1990-01-01"    |
|	"43311"	|	"F"	|	"111"	|	"1990-02-01"	|
|	"43311"	|	"M"	|	"112"	|	"1990-03-01"	|
|	"43311"	|	"F"	|	"113"	|	"1990-04-01"	|
|	"43311"	|	"M"	|	"114"	|	"1990-05-01"	|
|	"43311"	|	"F"	|	"115"	|	"1990-01-01"	|
|	"43311"	|	"M"	|	"116"	|	"1990-02-01"	|
|	"43311"	|	"F"	|	"117"	|	"1990-03-01"	|
|	"43311"	|	"M"	|	"118"	|	"1990-04-01"	|
|	"43311"	|	"F"	|	"119"	|	"1990-05-01"	|
|	"43311"	|	"M"	|	"120"	|	"1990-01-01"	|
|	"43311"	|	"M"	|	"121"	|	"1990-02-01"	|
|	"43311"	|	"F"	|	"122"	|	"1990-03-01"	|
|	"43311"	|	"M"	|	"123"	|	"1990-04-01"	|
|	"43311"	|	"F"	|	"124"	|	"1990-05-01"	|
# |	"43311"	|	"M"	|	"125"	|	"1990-01-01"	|

##########################################################################
    Scenario Outline: Success 200 2000 companyCode 
        When request 
            """
                {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
            """
        When method post
        Then status 200
        Then match response.statusCode == "0000"
        Then match response.statusDescription == "Success"
        Then match response.companyCode == "594911"
        Examples:
|	zip		|gender	|	id		|		DOB		    |
|	"43311"	|	"M"	|	"125"	|	"1990-01-01"	|

##################################################################################
Scenario Outline: Partial Success 200 0001 Invalid parameters
        When request 
            """
                {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
            """
        When method post
        Then status 200
        Then match response.statusCode == "0001"
        Then match response.statusDescription == "Partial Success. Please validate the IDs that were not returned."
        Examples:
            |	 zip	|gender	|	id		|		DOB		    |
            |	"43311"	|	"M"	|	"100"	|	"1990-01-01"	|
            |	"43311"	|	"F"	|	"101"	|	"1990-02-01"	|
            |"99999"    |"M"    |"18623589021"      |"1984-06-01"   |
            |"33033"    |"F"    |"18623589021"      |"1984-06-01"   |
            |"99999"    |"M"    |"125"              |"1990-01-01"   |            
            |"43311"    |"F"    |"125"              |"1990-01-01"   |
            |"43311"    |"M"    |"125"              |"2000-01-01"   |

# ##########################################################################
    Scenario Outline: missing parameters
        When request 
            """
                {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
            """
        When method post
        Then status 400
        Then match response.statusCode == "1101"
        Then match response.statusDescription == "The parameters you seem to have provided does not seem to be valid. Please see errors array or refer the developer portal to ensure you are building to specifications."
        Examples:
            |	zip	    |gender	|	id     	|DOB            |
            |""         |"M"    |"105"      |"1990-01-01"   |
            |"43311"    |""     |"105"      |"1990-01-01"   |
            |"43311"    |"M"    |""         |"1990-01-01"   |
            # |"43311"    |"M"    |"105"      |""             |

##########################################################################
    Scenario: unauthorized
        Given header x-api-key = "wrongkey"
        When request 
            """
                {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
            """
        When method post
        Then status 401
        Then match response.statusCode == "1000"
        Then match response.statusTitle == "Unauthorized"

#########################################################################
# Scenario Outline: notFound
#     When request 
#         """
#             {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
#         """
#     When method post
#     Then status 200
#     Then response.statusCode == "0001"
#     Then response.statusDescription == "Partial Success. Please validate the IDs that were not returned."
#         Examples:
#     |	zip	    |gender	|	id     	        |DOB            |
#     |"43311"    |"M"    |"XXX"              |"1990-01-01"   |
#     |"43311"    |"M"    |" 125"             |"1990-01-01"   |
#     |"43311"    |"M"    |"125 "             |"1990-01-01"   |
#     |"43311"    |"M"    |"126"              |"1990-01-01"   |

##########################################################################
    Scenario Outline: ELIG=Y, AUTH=Y, CORP=Y, STORE=Y
        When request 
            """
                {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
            """
        When method post
        Then status 200
        Then match response.statusCode == "0000"
        Then match response.statusDescription == "Success"
        Then match response.companyCode == "592308"
        Then match response.covidTestingEligible == "true"
        Then match response.employeeConsentRequired == "true"
        Then match response.storeScheduling == "true"
        Then match response.corporateScheduling == "true"
        Examples:
|	zip		|gender	|id		    |		DOB		|
|	"43311"	|	"M"	|	"100.1"	|	"1990-01-01"	|
|	"43311"	|	"F"	|	"108"	|	"1990-04-01"	|

# ##########################################################################
    Scenario Outline: ELIG=Y, AUTH=Y, CORP=Y, STORE=N
        When request 
            """
                {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
            """
        When method post
        Then status 200
        Then match response.statusCode == "0000"
        Then match response.statusDescription == "Success"
        Then match response.companyCode == "592308"
        Then match response.covidTestingEligible == "true"
        Then match response.employeeConsentRequired == "true"
        Then match response.storeScheduling == "true"
        Then match response.corporateScheduling == "false"
        Examples:
|	zip		|gender	|		id	|		DOB		|
|	"43311"	|	"M"	|	"102"	|	"1990-03-01"	|
|	"43311"	|	"F"	|	"106"	|	"1990-02-01"	|
# |	"43311"	|	"F"	|	"101-1"	|	"1990-02-01"	|
# |	"43311"	|	"M"	|	"105"	|	"1990-01-01"	|


##########################################################################    
Scenario Outline: ELIG=Y, AUTH=Y, CORP=N, STORE=Y
        When request 
            """
                {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
            """
        When method post
        Then status 200
        Then match response.statusCode == "0000"
        Then match response.statusDescription == "Success"
        Then match response.companyCode == "592308"
        Then match response.covidTestingEligible == "true"
        Then match response.employeeConsentRequired == "true"
        Then match response.storeScheduling == "false"
        Then match response.corporateScheduling == "true"
        Examples:
|	zip		|gender |		id		|		DOB		|
# |	"43311"	|	"M"	|	"102"	|	"1990-03-01"	|
# |	"43311"	|	"F"	|	"106"	|	"1990-02-01"	|
|	"43311"	|	"F"	|	"101-1"	|	"1990-02-01"	|
|	"43311"	|	"M"	|	"105"	|	"1990-01-01"	|

##########################################################################
Scenario Outline: ELIG=Y, AUTH=N, CORP=Y, STORE=Y
        When request 
            """
                {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
            """
        When method post
        Then status 200
        Then match response.statusCode == "0000"
        Then match response.statusDescription == "Success"
        Then match response.companyCode == "592308"
        Then match response.covidTestingEligible == "true"
        Then match response.employeeConsentRequired == "false"
        Then match response.storeScheduling == "true"
        Then match response.corporateScheduling == "true"
        Examples:
|	zip		|gender	|	id		|		DOB		|
|	"43311"	|	"F"	|	"103"	|	"1990-04-01"	|
|	"43311"	|	"M"	|	"107"	|	"1990-03-01"	|

##########################################################################
#     Scenario Outline: ELIG=N, AUTH=N, CORP=N, STORE=N
#         When request 
#             """
#                 {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
#             """
#         When method post
#         Then status 200
#         Then match response.statusCode == "0000"
#         Then match response.statusDescription == "Success"
#         Then match response.companyCode == "592308"
#         Then match response.covidTestingEligible == "false"
#         Then match response.employeeConsentRequired == "false"
#         Then match response.storeScheduling == "false"
#         Then match response.corporateScheduling == "false"
#         Examples:
#             |	zip	    |gender	|	id     	    |DOB            |


##########################################################################
    # Scenario Outline: ELIG=N, AUTH=Y, CORP=Y, STORE=N
    #     When request 
    #         """
    #             {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
    #         """
    #     When method post
    #     Then status 200
    #     Then match response.statusCode == "0000"
    #     Then match response.statusDescription == "Success"
    #     Then match response.companyCode == "592308"
    #     Then match response.covidTestingEligible == "false"
    #     Then match response.employeeConsentRequired == "true"
    #     Then match response.storeScheduling == "true"
    #     Then match response.corporateScheduling == "false"
    #     Examples:
    #         |	zip	    |gender	|	id     	    |DOB            |
    #         |"96789"    |"M"    |"39843458"     |"1996-06-01"   |

##########################################################################
    # Scenario Outline: ELIG=Y, AUTH=N, CORP=N, STORE=N
    #     When request 
    #         """
    #             {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
    #         """
    #     When method post
    #     Then status 200
    #     Then match response.statusCode = "0000"
    #     Then match response.statusDescription = "Success"
    #     Then match response.companyCode = "592308"
    #     Then match response.covidTestingEligible = "true"
    #     Then match response.employeeConsentRequired = "false"
    #     Then match response.storeScheduling = "false"
    #     Then match response.corporateScheduling = "false"
    #     Examples:
    #         |	zip	    |gender	|	id     	        |DOB            |
    #         |"75013"    |"F"    |"83377589491"      |"1976-03-01"   |

##########################################################################
#     Scenario Outline: ELIG=Y, AUTH=Y, CORP=N, STORE=N
#         When request 
#             """
#                 {"zip": <zip>,"gender": <gender>,"id": <id>,"dateOfBirth": <DOB>} 
#             """
#         When method post
#         Then status 200
#         Then match response.statusCode == "0000"
#         Then match response.statusDescription == "Success"
#         Then match response.companyCode == "592308"
#         Then match response.covidTestingEligible == "true"
#         Then match response.employeeConsentRequired == "true"
#         Then match response.storeScheduling == "false"
#         Then match response.corporateScheduling == "false"
#         Examples:
# |		zip		|		gender		|		id		|		DOB		|
# |	"	43311	"	|	"	F	"	|	"	101	"	|	"	1990-02-01	"	|
# |	"	43311	"	|	"	M	"	|	"	105	"	|	"	1990-01-01	"	|

##########################################################################



