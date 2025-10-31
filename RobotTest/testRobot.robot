*** Settings ***
Library    SeleniumLibrary
Library    XML

*** Variables ***

#Locators
${loc_inputfile}             id:inputFile
${loc_xmlfile}               id:xmlFile
${loc_addIgRuleBtn}          id:addIgRuleBtn
${loc_rule-prefix}           class:rule-prefix
${loc_rule-value}            class:rule-value
${loc_addMappingBtn}         id:addMappingBtn
${loc_mappingprefix}         xpath://*[@id="mappingRulesContainer"]/div/input[1]
${loc_mappingsuffix}         xpath://*[@id="mappingRulesContainer"]/div/input[2]
${loc_generateBtn}           id:generateBtn
${loc_downloadBtn}           id:downloadBtn


#Variables
${XML_FILE_PATH}=       C:\\Users\\Jenny\\Downloads\\options.xml

${SuccessText}        DAT-filen har genererats framgångsrikt!
${outputPreview}     id:outputPreview


*** Test Cases ***

Testing Dat file
    [Documentation]    This test takes files and compares them.
    Navigate to webpage
    Get files
    Add IG and Mapping
    Generate File

*** Keywords ***
Navigate to webpage
    Open Browser     https://kztp47.github.io/Karokh-Arafs-dat-file-generator/    chrome
    Maximize Browser Window


Get files
    [Documentation]    This gets the actual files, sending errors if the files are not received
    [Arguments]    ${CSVFile}=C:\\Users\\Jenny\\Downloads\\Blad1.csv   ${XMLFile}=C:\\Users\\Jenny\\Downloads\\xlm INPUT file.xml
    Wait Until Page Contains Element     ${loc_inputfile}
    Choose File          ${loc_inputFile}             ${CSVFile}
    Choose File          ${loc_xmlFile}               ${XMLFile}

Add IG and Mapping
    [Arguments]    ${PreDivNr}=1    ${SufDivNr}=1    ${MPreDivNr}=1    ${MSufDivNr}=1
    ${xml}=    Parse Xml    ${XML_FILE_PATH}
    @{IGPre}=    Get Elements    ${xml}    .//IG/Pre
    @{IGSuf}=    Get Elements    ${xml}    .//IG/Suf
    @{MAPPINGPre}=     Get Elements    ${xml}    .//MAPPING/Pre
    @{MAPPINGSuf}=     Get Elements    ${xml}    .//MAPPING/Suf
    Wait Until Page Contains Element     ${loc_addIgRuleBtn}
    FOR    ${prefix}    IN    @{IGPre}
        Click Button     ${loc_addIgRuleBtn}
        ${prefixText} =     Get Element Text    ${prefix}
        Input text       //*[@id="igRulesContainer"]/div[${PreDivNr}]/input[1]    ${prefixText}
        ${PreDivNr} =  Evaluate    ${PreDivNr}+1
    END
    FOR    ${suffix}    IN    @{IGSuf}
         Run Keyword If         ${PreDivNr}<=${SufDivNr}        Click Button     ${loc_addIgRuleBtn}
         ${suffixText} =     Get Element Text    ${suffix}
         Input text       //*[@id="igRulesContainer"]/div[${SufDivNr}]/input[2]       ${suffixText}
         ${SufDivNr} =  Evaluate    ${SufDivNr}+1
    END
    FOR    ${prefix}    IN    @{MAPPINGPre}
        Click Button     ${loc_addMappingBtn}
        ${prefixText} =     Get Element Text    ${prefix}
        Input text       //*[@id="mappingRulesContainer"]/div[${MPreDivNr}]/input[1]       ${prefixText}
        ${MPreDivNr} =  Evaluate    ${MPreDivNr}+1
    END
    FOR    ${suffix}    IN    @{MAPPINGSuf}
        Run Keyword If         ${MPreDivNr}<=${MSufDivNr}        Click Button     ${loc_addMappingBtn}
        ${suffixText} =     Get Element Text    ${suffix}
        SeleniumLibrary.Input text       //*[@id="mappingRulesContainer"]/div[${MSufDivNr}]/input[2]       ${suffixText}
        ${MSufDivNr} =  Evaluate    ${MSufDivNr}+1
    END

Generate File
    SeleniumLibrary.Click Button  ${loc_generateBtn}
    Scroll Element Into View    ${outputPreview}
    Page Should Contain        ${SuccessText}
    SeleniumLibrary.Click Button    ${loc_downloadBtn}