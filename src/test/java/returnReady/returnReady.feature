@rReady
Feature: Return Eligibility API for apigee endpoints
   Background: Setup
   * url 'https://www-reg2.cvs.com/'
   * def eligibilityData = read('classpath:data/returnReady/returnReady-eligibility.json')
   Scenario Outline: Make a valid Eligibility
   * def eligibilityPayLoad = eligibilityData.TC001_returnready.requestPayLoad
   * def apikeyHeader = eligibilityData.TC001_returnready.headers.apiKey
   #* def mockFlag = eligibilityData.TC001_returnready.headers.isMock
    Given path 'mcapi/returnready/v1/covid-eligibility'
    And header x-api-key = apikeyHeader
    #And header x-mock = mockFlag
    And request
    """
        {
            "zip": <zip>,
            "gender": <gender>,
            "id": <id>,
            "dateOfBirth": <dateOfBirth>
        }
        """
    When method post
    Then status 200

    Examples:
|	zip	     |	gender	|	id     	 |	dateOfBirth	 |
|"33033"   |"M"   |"98797584221	"|"1963-11-01"|
|"30338"|"F"   |"90875584691"|"1962-06-01"|
|"75013"|"M"   |"90894558499"|"1964-03-01"|
|"93306"|"M"   |"94859989"|"1974-11-01"|
|"96789"|"M"   |"94878658989"|"1975-09-01"|
|"85032"|"M"   |"96306958489"|"1964-10-01"|
|"87110"|"M"   |"965582589"|"1974-11-01"	|
|"60655"|"F"   |"96669958989"|"1974-04-01"|
|"93306"|"F"   |"36548658"|"1990-04-01"|
|"85032"|"F"   |"46345658800"|"1958-01-01"|
|"87110"|"F"   |"46541075849"|"1958-09-01"|
|"60655"|"F"   |"46818385871"|"1958-02-01"|
|"75212"|"M"   |"49829558459"|"1963-06-01"|
|"60089"|"M"   |"15281768879"|"1999-07-01"|
|"33033"|"M"   |"12876382"|"1999-07-01"|
|"87110"|"M"   |"89866358990"|"1988-09-01"|
|"60655"|"M"   |"90859195812"|"1968-10-01"|
|"75212"|"M"   |"93249589121"|"1970-07-01"|
|"33033"|"M"   |"65718558992"|"1978-10-01"|
|"87110"|"M"   |"974649"    |"1993-05-01"|
|"60655"|"M"   |"8858099"    |"1993-04-01"|
|"75212"|"F"   |"93613398001"|"1992-01-01"|
|"60089"|"M"   |"93918878842"|"1996-06-01"|
|"33033"|"M"   |"94484158432"|"1960-08-01"|
|"30338"|"M"   |"94489518432"|"1960-08-01"|
|"75013"|"M"   |"94484682"|"1959-12-01"|
|"10038"|"F"   |"9498908489"|"1969-03-01"|
|"10280"|"M"   |"9748358702"|"1954-09-01"|
|"07097"|"F"   |"9498908456"|"1969-03-01"|


   