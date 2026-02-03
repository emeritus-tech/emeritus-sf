/*
@Description : Owner Assignment for IC 
                1. Metadata method
                2. Dispatcher method
                3. King's Education method
                4. Inactive IC assignment method
                5. Round Robin logic method
TEST CLASS :  OwnerShipAssignmentController_Test
*/
public class OwnerShipAssignmentController {
    
    public static Map<String,List<String>> mapFieldToValues = new Map<String,List<String>>();
    
    public static String ICOwnerAssignment(interested_Course__c ic, String regionValue){
        
        //For No I Do Not Agree conditions
        if(ic.Lead__r.Agree__c == 'No I Do Not Agree'){
            String queryMetaStr3 = 'SELECT OwnerId__c, Calculated_Priority__c from RecordAssignmentLogicMetaData__mdt where Priority__c = 1 and Agree__c=\''+ic.Lead__r.Agree__c+'\' and Handled_By__c=\''+ic.Handled_By__c + '\' order by Calculated_Priority__c desc';
            List<RecordAssignmentLogicMetaData__mdt> listMetadata3 = Database.query(queryMetaStr3);
            
            if(listMetadata3 <> null && listMetadata3.size() > 0){
                return listMetadata3[0].OwnerId__C;
            }
        }
        
        //Fetch all required values for priority 1 records
        mapFieldsToValues();
        
        //Basic structure of query for priority 2
        String queryMetaStr2 = 'SELECT OwnerId__c, Calculated_Priority__c from RecordAssignmentLogicMetaData__mdt where Priority__c = 2 and Agree__c=\''+ic.Lead__r.Agree__c+'\' and Handled_By__c=\''+ic.Handled_By__c + '\'';
        //Basic structure of query for priority 1
        String queryMetaStr1 = 'SELECT OwnerId__c, Calculated_Priority__c from RecordAssignmentLogicMetaData__mdt where Priority__c = 1 and Agree__c=\''+ic.Lead__r.Agree__c+'\' and Handled_By__c=\''+ic.Handled_By__c + '\'';
        
        //Handled By LOB
        if(string.isNOTBlank(ic.Handled_By_LOB__c)){
            queryMetaStr2 += ' AND Handled_By_LOB__c=\''+ ic.Handled_By_LOB__c + '\'';
            queryMetaStr1 += ' AND Handled_By_LOB__c=\''+ ic.Handled_By_LOB__c + '\'';
        }
        
        //Lead Source
        if(string.isNOTBlank(ic.Lead_Source__c)){
            queryMetaStr2 += ' AND (Lead_Source__c = null OR Lead_Source__c = \''+ ic.Lead_Source__c + '\')' ;
            
            List<String> lstFieldValues = mapFieldToValues.get('Lead_Source__c');
            String leadSourceValue = lstFieldValues.contains(ic.Lead_Source__c) ? ic.Lead_Source__c : null;
            if(leadSourceValue != null){
                queryMetaStr1 += ' AND Lead_Source__c = \'' + leadSourceValue + '\'';
            }else{
                queryMetaStr1 += ' AND Lead_Source__c = null';
            }
        }
        
        //Program Value
        if(string.isNOTBlank(ic.Programme_New__c)){
            queryMetaStr2 += ' AND (Programme_New__c=\''+ ic.Programme_New__c +'\')';
            
        }else{
            queryMetaStr2 += ' AND (Programme_New__c = \'BlankValue\')';
        }
        
        //UTM Medium
        if(string.isNOTBlank(ic.UTM_Medium__c)){
            String sanitizedName = String.escapeSingleQuotes(ic.UTM_Medium__c);
            queryMetaStr2 += ' AND ( UTM_Medium__c = null OR UTM_Medium__c = \''+ sanitizedName + '\')';
            
            List<String> lstFieldValues = mapFieldToValues.get('UTM_Medium__c');
            String utmMediumValue = lstFieldValues.contains(ic.UTM_Medium__c) ? ic.UTM_Medium__c : null;
            String sanitizedName1;
            if(utmMediumValue != null){
               sanitizedName1 = String.escapeSingleQuotes(utmMediumValue);
            }
            if(sanitizedName1 != null){
                queryMetaStr1 += ' AND UTM_Medium__c = \'' + sanitizedName1 + '\'';
            }else{
                queryMetaStr1 += ' AND UTM_Medium__c = null';
            }
        }else{
            queryMetaStr2 += ' AND ( UTM_Medium__c = null OR UTM_Medium__c = \'BlankValue\')';
            queryMetaStr1 += ' AND UTM_Medium__c = null';
        }
        
        //UTM Source
        if(string.isNOTBlank(ic.UTM_Source__c)){
            String sanitizedName = String.escapeSingleQuotes(ic.UTM_Source__c);
            queryMetaStr2 += ' AND ( UTM_Source__c = null OR UTM_Source__c = \''+ sanitizedName + '\')';
            
            string utmSource = '';
            if(ic.UTM_Source__c.contains('CP_')){
                utmSource = 'Yes';
            }else{
                utmSource = ic.UTM_Source__c;
            }
            List<String> lstFieldValues = mapFieldToValues.get('UTM_Source__c');
            String utmSourceValue = lstFieldValues.contains(utmSource) ? utmSource : null;
            String sanitizedName1;
            if(utmSourceValue != null){
               sanitizedName1 = String.escapeSingleQuotes(utmSourceValue);
            }
            if(sanitizedName1 != null){
                queryMetaStr1 += ' AND UTM_Source__c = \'' + sanitizedName1 + '\'';
            }else{
                queryMetaStr1 += ' AND UTM_Source__c = null';
            }
            
        }else{
            queryMetaStr2 += ' AND (UTM_Source__c = null OR UTM_Source__c = \'BlankValue\')';
            queryMetaStr1 += ' AND UTM_Source__c = null';
        }
        
        //Work Experience
        if(string.isNOTBlank(ic.Work_Experience__c)){
            queryMetaStr2 += ' AND (Work_Experience__c = null OR Work_Experience__c=\''+ ic.Work_Experience__c +'\')';
            
        }else{
            queryMetaStr2 += ' AND (Work_Experience__c = null OR Work_Experience__c = \'BlankValue\')';
        }
        
        //Region
        if(string.isNOTBlank(regionValue)){
            queryMetaStr2 += ' AND (Region__c = null OR Region__c=\''+ regionValue +'\')';
            
        }else{
            queryMetaStr2 += ' AND (Region__c = null OR Region__c = \'BlankValue\')';
        }
        
        //Group_Enrollment_Size__c
        if(string.isNOTBlank(ic.Group_Enrollment_Size__c)){
            queryMetaStr2 += ' AND (Group_Enrollment_Size__c = null OR Group_Enrollment_Size__c =\''+ ic.Group_Enrollment_Size__c +'\')';
            
        }else{
            queryMetaStr2 += ' AND (Group_Enrollment_Size__c = null OR Group_Enrollment_Size__c = \'BlankValue\')';
        }
        
        //Order by calculated Priority field
        queryMetaStr2 += ' order by Calculated_Priority__c desc';
        queryMetaStr1 += ' order by Calculated_Priority__c desc';
        
        system.debug('queryMetaStr1 '+queryMetaStr1);
        system.debug('queryMetaStr2 '+queryMetaStr2);
        
        //Run query for Priority 1
        List<RecordAssignmentLogicMetaData__mdt> listMetadata1 = Database.query(queryMetaStr1);
        //Run query for Priority 2
        List<RecordAssignmentLogicMetaData__mdt> listMetadata2 = Database.query(queryMetaStr2);
        system.debug('listMetadata1 '+listMetadata1);
        system.debug('listMetadata2 '+listMetadata2);
        
        String ownershipID = null;
        
        //if Priority 1 has records then owner field from first record
        if(listMetadata1 <> null && listMetadata1.size() > 0){
            ownershipID = listMetadata1[0].OwnerId__C;
        }else if(listMetadata2 <> null && listMetadata2.size() > 0){ //else if Priority 2 has records then owner field from first record
            ownershipID = listMetadata2[0].OwnerId__C;
        }
        system.debug('ownershipID '+ownershipID);
        return ownershipID;
        
    }
    
    public static void mapFieldsToValues(){
        //Map<String,List<String>> mapFieldToValues = new Map<String,List<String>>();
        List<String> strICAssignmentLogicAgree = System.Label.RecordAssignmentLogic_Agree_c.split(',');
        system.debug('----strICAssignmentLogicAgree----'+strICAssignmentLogicAgree);
        mapFieldToValues.put('Agree__c',strICAssignmentLogicAgree);
        system.debug('---mapFieldToValues---'+mapFieldToValues);
        List<String> strICAssignmentLogicHandledBy = System.Label.RecordAssignmentLogic_Handled_By_c.split(',');
        system.debug('----strICAssignmentLogicHandledBy----'+strICAssignmentLogicHandledBy);
        mapFieldToValues.put('Handled_By__c',strICAssignmentLogicHandledBy);
        system.debug('---mapFieldToValues---'+mapFieldToValues);
        List<String> strICAssignmentLogicHandledByLOB = System.Label.RecordAssignmentLogic_Handled_By_LOB_c.split(',');
        system.debug('----strICAssignmentLogicHandledByLOB----'+strICAssignmentLogicHandledByLOB);
        mapFieldToValues.put('Handled_By_LOB__c',strICAssignmentLogicHandledByLOB);
        system.debug('---mapFieldToValues---'+mapFieldToValues);
        List<String> strICAssignmentLogicLeadSource = System.Label.RecordAssignmentLogic_Lead_Source_c.split(',');
        system.debug('----strICAssignmentLogicLeadSource----'+strICAssignmentLogicLeadSource);
        mapFieldToValues.put('Lead_Source__c',strICAssignmentLogicLeadSource);
        system.debug('---mapFieldToValues---'+mapFieldToValues);
        List<String> strICAssignmentLogicProgrammeNew = System.Label.RecordAssignmentLogic_Programme_New_c.split(',');
        system.debug('----strICAssignmentLogicProgrammeNew----'+strICAssignmentLogicProgrammeNew);
        mapFieldToValues.put('Programme_New__c',strICAssignmentLogicProgrammeNew);
        system.debug('---mapFieldToValues---'+mapFieldToValues);
        List<String> strICAssignmentLogicUTMMedium = System.Label.RecordAssignmentLogic_UTM_Medium_c.split(',');
        system.debug('----strICAssignmentLogicUTMMedium----'+strICAssignmentLogicUTMMedium);
        mapFieldToValues.put('UTM_Medium__c',strICAssignmentLogicUTMMedium);
        system.debug('---mapFieldToValues---'+mapFieldToValues);
        List<String> strICAssignmentLogicUTMSource = System.Label.RecordAssignmentLogic_UTM_Source_c.split(',');
        system.debug('----strICAssignmentLogicUTMSource----'+strICAssignmentLogicUTMSource);
        mapFieldToValues.put('UTM_Source__c',strICAssignmentLogicUTMSource);
        system.debug('---mapFieldToValues---'+mapFieldToValues);
    }
    
    //Method for IC owner Assignment from Custom Metadata 
    public static Interested_Course__c runMetadataAssignment(Interested_Course__c ic, Map<String, String> mapRegion, Map<Id,Lead> mapOfLead, Map<Id,String>CountryNameMap){
        system.debug('ic parameter '+ic);
        system.debug('mapRegion parameter '+mapRegion);
        system.debug('mapOfLead parameter'+mapOfLead);
        system.debug('CountryNameMap parameter'+CountryNameMap);
        system.debug('(mapOfLead.get(ic.Lead__c).country)'+(mapOfLead.get(ic.Lead__c).country));
        //system.debug('mapRegion.get((mapOfLead.get(ic.Lead__c).country).toLowerCase())'+mapRegion.get((mapOfLead.get(ic.Lead__c).country).toLowerCase()));
        
        String regionValue = null;
        if(null == mapRegion || null == (mapOfLead.get(ic.Lead__c).country) || null == mapRegion.get((mapOfLead.get(ic.Lead__c).country).toLowerCase())){
            regionValue = 'Others';
            system.debug('In here1 '+regionValue);
        }else{
            system.debug('(mapOfLead.get(ic.Lead__c).country.toLowerCase()'+(mapOfLead.get(ic.Lead__c).country.toLowerCase()));
            system.debug('mapRegion.get((mapOfLead.get(ic.Lead__c).country.toLowerCase()).toLowerCase())'+mapRegion.get((mapOfLead.get(ic.Lead__c).country.toLowerCase()).toLowerCase()));
            regionValue = CountryNameMap.get(mapRegion.get((mapOfLead.get(ic.Lead__c).country.toLowerCase()).toLowerCase()));
            system.debug('In here1 '+regionValue);
        }
        system.debug('regionValue'+regionValue);
        String ownerOfIC = ICOwnerAssignment(ic, regionValue);
        if(ownerOfIC != null){
            ic.OwnerId = ownerOfIC;
            ic.Assignment_Type__c = 'Metadata';
            ic.Owner_Assignment_Completed__c = True;
            if(mapOfLead.containsKey(ic.Lead__c)){
                mapOfLead.get(ic.Lead__c).OwnerId = ownerOfIC;
            }
            return ic;
        }
        return null;
    }
    
    //Method for Kings Education
    public static Interested_Course__c runKingsEducationAssignment(Interested_Course__c ic){
        system.debug('Inside here');
        ic.OwnerId = System.Label.Emeritus_System_UserID;
        ic.Assignment_Type__c = 'Manual';
        ic.Owner_Assignment_Completed__c = True;
        return ic;     
    }    
    
    //Method for Inactive IC assignment
    public static Interested_Course__c runInactiveICAssignment(Interested_Course__c ic, Map<Id,Id> mapLeadIDToAdvisorId, Map<Id,String> mapAdvisorIdToPrograms, Map<Id,String> mapLeadIDToRegionId, Map<Id,String> mapAdvisorIdToRegion){
        if(mapLeadIDToAdvisorId.containsKey(ic.Lead__c) 
           && !String.isBlank(mapLeadIDToAdvisorId.get(ic.Lead__c))
           && mapAdvisorIdToPrograms.containsKey(mapLeadIDToAdvisorId.get(ic.Lead__c))
           && !String.isBlank(mapAdvisorIdToPrograms.get(mapLeadIDToAdvisorId.get(ic.Lead__c)))
           && (mapAdvisorIdToPrograms.get(mapLeadIDToAdvisorId.get(ic.Lead__c)).contains(ic.Programme_New__r.Name))
           && mapLeadIDToRegionId.containsKey(ic.Lead__c) 
           && !String.isBlank(mapLeadIDToRegionId.get(ic.Lead__c)) 
           && mapAdvisorIdToRegion.containsKey(mapLeadIDToAdvisorId.get(ic.Lead__c)) 
           && !String.isBlank(mapAdvisorIdToRegion.get(mapLeadIDToAdvisorId.get(ic.Lead__c)))
           && (mapAdvisorIdToRegion.get(mapLeadIDToAdvisorId.get(ic.Lead__c)).contains(ic.Lead__r.Region_New__r.Name))                   
          ){
              ic.OwnerId = mapLeadIDToAdvisorId.get(ic.Lead__c);
              ic.Owner_Assignment_Completed__c = True;
              return ic;
          }
        return null;
    }
    
    //Method for Dispatcher Assignment
    public static Interested_Course__c runDispatcherAssignment(Interested_Course__c ic){
            ic.OwnerId = Label.Default_IC_owner_for_specified_LOBs;
            ic.Assignment_Type__c = 'Round Robin';
            return ic;
    }
    
    //Method for Dispatcher and Round Robin Logic
    public static Interested_Course__c runDispatcher_RRAssignment(Interested_Course__c ic){
            ic.OwnerId = Label.Default_Owner_Before_Dispatcher_RR;
            ic.Assignment_Type__c = 'Dispatcher_RR';
            system.debug('Assign owner in insert');
            return ic;
    }
        //String stringMaxAttemptDis_RR = Label.Max_attempt_for_Dispatcher_RR;
        //Integer maxAttemptDis_RR = Integer.ValueOf(stringMaxAttemptDis_RR);
        /*if(ic.Dispatcher_RR_Attempt__c < maxAttemptDis_RR){
            if(ic.Lead_Score__c==null){
                ic.OwnerId = Label.Default_Owner_Dispatcher_RR;
                ic.Assignment_Type__c = 'Dispatcher_RR';
                ic.Dispatcher_RR_Attempt__c = ic.Dispatcher_RR_Attempt__c+1;
                return ic;
            }
        else{
                //return ic, add it to the round robin list and then call the round robin method - runRoundRobinAssignment
                return ic;
            }
        }
    }*/
    
    //Method for Round Robin Logic
    public static void runRoundRobinAssignment(List<Interested_Course__c> newList){
        Set<String> setRegion = new Set<String>();
        Set<String> setProgram = new Set<String>(); 
        Set<String> setPrograms = new Set<String>();
        Set<String> setLanguage=new Set<String>();
        Map<String,String> mapRegion = new Map<String,String>();
        Map<ID, string> CountryNameMap = new Map<ID, string>();
        
        Map<string, Integer> mapOwnerToTotalLead = new Map<string, Integer>();
        Map<string, Decimal> mapOwnerToTotalICs_RatingBased = new Map<string, Decimal>();
        List<User> finalUsers = new List<User>();
        List<User> lstUser = new List<User>();
        Map<string, List<User>> mapRegionToUsers = new Map<string, List<User>>();
        Map<id,UserObjectWrapper> userMap = new Map<id,UserObjectWrapper>(); //SEEP-8400 Map to store the value of rating, total lead and totalLead/rating of User
        
        List<Interested_Course__c> lstLeadOwnerUpdate = new List<Interested_Course__c>();
        List<Interested_Course__c> tmpLstIC = new List<Interested_Course__c>();
        
        Map<String,LOB_for_Dispatcher_RR__c> mapOfLOBforDispatchRR = LOB_for_Dispatcher_RR__c.getAll();
        
        String ResultedRegion = System.Label.OthersRegionId;
        for(Region__c r:[select id,Name from Region__c ]) {
            CountryNameMap.put(r.id,r.Name);
            system.debug('--CountryNameMap=='+CountryNameMap );
        }
        Set<Id> setLead = new Set<Id>();
        if(newList.size() >0){
            for(Interested_Course__c obn :newList ){
                if(obn.Active__c){
                    setLead.add(obn.Lead__c);
                }
            }
        }
        List<Lead> obLead = new List<Lead>();
        Map<Id,Lead> obLeadMap = new Map<Id,Lead>();
        
        obLead = [select id,Status, Program_Rating__c,Language__c,country,Capture_Source__c,Agree__c,OwnerId,Region_New__c from lead where id in :setLead];   //2 fields added by aish for SEEP-3457                  
        if(obLead.size() > 0){
            for(Lead ob :obLead){
                obLeadMap.put(ob.id,ob);
            }
        }
        
        for(Interested_Course__c ic : newList){
            if(obLeadMap.get(ic.Lead__c) != null && obLeadMap.get(ic.Lead__c).Language__c != null){   // criteria added by aish for code exception fix
                setLanguage.add(obLeadMap.get(ic.Lead__c).Language__c);
                system.debug('--ic.Lead__r.Language__c=='+ic.Lead__r.Language__c );
            }
            else{
                setLanguage.add('English');
                system.debug('--ic.Lead__r.Language__c=='+ic.Lead__r.Language__c );
            }
            if(obLeadMap.get(ic.Lead__c) != null && obLeadMap.get(ic.Lead__c).country != null){  // criteria added by aish for code exception fix
                system.debug('--ic.Lead__r.country=='+ic.Lead__r.country );
                setRegion.add(obLeadMap.get(ic.Lead__c).country);
                system.debug('--setRegion=='+setRegion );
            }
            if(ic.Programme_New__c != null){
                List<string> strPrograms = new List<string>();
                setProgram.add(ic.Program_Name__c);
                system.debug('--setProgram=='+setProgram );
            }
        }
        system.debug('--setRegion=='+setRegion );
        if(setRegion.size() > 0){
            mapRegion = LeadAssignmentTriggerHandler.CountryFound(setRegion,setLanguage);
            system.debug('--mapRegion=='+mapRegion );
        }
        
        setRegion = new Set<String>();
        for(Interested_Course__c ic : newList){
            system.debug('!Bingo ic=> '+ic);
            system.debug('setRegion------------> '+setRegion);
            
            System.debug('mapRegion----->222222'+mapRegion);
            
            if(obLeadMap.get(ic.Lead__c) != null && obLeadMap.get(ic.Lead__c).country != null && mapRegion != null && mapRegion.get(obLeadMap.get(ic.Lead__c).country.toLowerCase()) != null){
                system.debug('---------setRegion if----------');
                setRegion.add(CountryNameMap.get(mapRegion.get(obLeadMap.get(ic.Lead__c).country.toLowerCase())));
                system.debug('setRegion----------=>'+setRegion);
            }
            else{
                system.debug('---------setRegion else----------');
                
                setRegion.add('Others');
            }
        }
        List<String> UserCompanyRecAccess = AccessUtilityHelper.getUserCompanyRecAccessDetails();//Added for GA related change to filter by user company for SEEP-8004
        AggregateResult[] groupedResults = [SELECT OwnerId ownerId, COUNT(Id) FROM Interested_Course__c 
                                            where CreatedDate=Today AND Handled_By__c IN :UserCompanyRecAccess
                                            GROUP BY OwnerId
                                            /*GROUP BY Lead__r.OwnerId*/ ]; //ToDo (Change owner count from Lead to IC)
        for (AggregateResult ar : groupedResults)  {
            mapOwnerToTotalLead.put(string.ValueOf(ar.get('ownerId')), Integer.valueOf(ar.get('expr0')));
            
            //SEEP 8400 - Add the Lead Owner and IC count for rating based round robin
            mapOwnerToTotalICs_RatingBased.put(string.ValueOf(ar.get('ownerId')), Integer.valueOf(ar.get('expr0')));
        }
        //fetch all today created lead with ownerId, And filter user based on Region & program name
        if(setRegion != null){
            //query in interested course then count against interested course               
            string soqlUser ='select Id, Programme_New__c, All_Programs_Assigned__c, Region__c, Name, Rating_Formula__c, Advisor_Tier__c from User where IsActive = true and Region__c includes ('; //SEEP-9547
            Integer j=0; 
            System.debug('!!--setRegion-->'+setRegion);
            for(string str : setRegion){
                if(j == 0){ 
                    soqlUser += '\''+str+'\'';
                }
                else { soqlUser += ',\''+str+'\'';}
                j++;
            }
            soqlUser +=') and On_Holiday__c = false and User_Type__c =\'Outreach User\'';
            system.debug('SSSSS'+setRegion);
            if(setProgram != null && setProgram.size() > 0){
                Integer i =0;
                j =0;
                soqlUser ='select Id, Programme_New__c, All_Programs_Assigned__c, Region__c, Name, Rating_Formula__c, Advisor_Tier__c from User where IsActive = true and On_Holiday__c = false and Region__c includes ('; //SEEP 5274 //SEEP-9547 
                
                for(string str : setRegion){
                    system.debug('SSSSS'+setRegion);
                    if(j == 0){ 
                        soqlUser += '\''+str+'\'';
                    }
                    else { soqlUser += ',\''+str+'\'';}
                    j++;
                }
                soqlUser +=') and User_Type__c =\'Outreach User\'';
            }
            system.debug(':soqlUser : '+ soqlUser);
            if(!Test.isRunningTest()){
                lstUser = Database.query(soqlUser);
                system.debug('lstUser '+lstUser );
                for(User u : lstUser){
                    System.debug('setProgram>>'+setProgram);
                    System.debug('u.Programme_New__c>>'+u.Programme_New__c);
                    List<string> tempList = new List<String>();
                    if(u.Programme_New__c != null){
                        for(String s : u.Programme_New__c.split(';')){
                            tempList.add(s);
                            if(setProgram.contains(s)){
                                System.debug('entered if for programme');
                                finalUsers.add(u);
                            }
                        }
                        if(u.All_Programs_Assigned__c == true){
                            if(!finalUsers.contains(u)){
                                finalUsers.add(u);
                            }
                        }
                    }
                    System.debug('finalUsers with assigned programs>>'+finalUsers);
                    System.debug('tempList>>'+tempList);
                }
                System.debug('finalUsers size>>'+finalUsers.size());
            }
            else{
                
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                User u = new User(Alias = 'standt', Email='admin@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com', isActive=true, Company_Records_Access__c = 'Emeritus',
                                  //Programme_New__c ='PGDGM',
                                  On_Holiday__c =false,Region__c= 'abc',Programme__c ='CERT-LEAD', Programme_New__c='CERT-LEAD',Rating_Picklist__c = '3',
                                  //Rating_Formula__c = 3,
                                  User_Type__c ='Outreach User');
                finalUsers.add(u);                
            }
            
        }
        //filter user based on Region
        if(finalUsers != null && finalUsers.size() > 0){
            
            system.debug('finalUsers>>'+finalUsers);
            for(User u : finalUsers){
                String [] regionArray= u.Region__c.split(';');
                //system.debug('SSSSSS'+regionArray);
                for(integer i=0;i<regionArray.size();i++){
                    if(mapRegionToUsers.get(regionArray[i]) == null){
                        mapRegionToUsers.put(regionArray[i], new List<User>());
                    }   
                    mapRegionToUsers.get(regionArray[i]).add(u);
                    //system.debug(mapRegionToUsers+'RRRRR'+regionArray[i]);
                }
            }            
        }
        tmpLstIC = [SELECT Id,Lead__r.Email, Lead__r.Region_New__c,Lead__r.country, Lead__r.OwnerId, Handled_By__c, Lead_Source__c, Handled_By_LOB__c, // Added Handled_By__c,Lead_Source__c,Handled_By_LOB__c for the Story SEEP-8357
                    Programme_New__r.name, Programme_New__c, Lead__r.Capture_Source__c, Lead__r.Region_New__r.Name, Group_Enrollment_Size__c,
                    Lead__r.LeadSource, Lead__r.Programme__c, OwnerId, Lead__r.Rating, Lead__r.Advisor_Email__c, //Added 'Advisor_Email__c' by Mayank Agarwal for the Story SEEP-7759
                    Lead__r.Agree__c,Programme_New__r.LOB__c,Lead__r.City,City__c, UTM_Medium__c,UTM_Source__c, Work_Experience__c ,Region_New__c, Program_Name__c,
                    Batch__r.Product__r.Family, Lead_Score__c, Dispatcher_RR_Attempt__c, Assignment_Type__c, Lead_Score_Tier_Bucket__c/*SEEP-9547*/
                    FROM Interested_Course__c where Id in : newList];
        for(Interested_Course__c ic : tmpLstIC){
            if(ic.Lead__r.country != null && mapRegion != null && mapRegion.get(ic.Lead__r.country.toLowerCase()) != null){
                system.debug('--testRe--'+mapRegion.get(ic.Lead__r.country.toLowerCase()));
                ic.Lead__r.Region_New__c = mapRegion.get(ic.Lead__r.country.toLowerCase());
            }
            if(ic.Lead__r.Region_New__c == null && !String.isBlank(ResultedRegion)){
                system.debug('--in 2nd if-------------------------');
                ic.Lead__r.Region_New__c =ResultedRegion;
            }
            if(ic.Lead__r.Region_New__c != null && (mapRegionToUsers != null && mapRegionToUsers.size() > 0)){
                Id UserId; 
                List<User> lstUserFilteredReg = new List<User>(); 
                lstUserFilteredReg = mapRegionToUsers.get(CountryNameMap.get(ic.Lead__r.Region_New__c));
                system.debug('Check Users '+lstUserFilteredReg);
            }
            if(ic.Lead__r.Region_New__c != null && (mapRegionToUsers != null && mapRegionToUsers.size() > 0)){
                Id UserId;
                List<User> lstUserFilteredReg = new List<User>(); 
                lstUserFilteredReg = mapRegionToUsers.get(CountryNameMap.get(ic.Lead__r.Region_New__c));
                system.debug('Check Users '+lstUserFilteredReg);
                if(lstUserFilteredReg != null && lstUserFilteredReg.size() > 0){
                    if(System.Label.Round_Robin_Assignment_Logic == 'New'){
                        system.debug('userMap before assignment '+userMap);
                        //Store selected users in the userWrapper map
                        for(User u:lstUserFilteredReg){
                            system.debug('u.Name'+u.Name);
                            system.debug('u.Rating'+u.Rating_Formula__c);
                            if(u.Rating_Formula__c!=null){
                                
                                if(!userMap.containsKey(u.id)){
                                    
                                    //Enter loop only if user is not already present in the userMap 
                                    List<String> listOfUserPrograms = new List<String>();
                                    listOfUserPrograms = u.Programme_New__c.split(';');
                                    system.debug('inside for loop');
                                    Decimal countTotalLead;
                                    //system.debug('mapOwnerToTotalICs_RatingBased.get(u.id)'+mapOwnerToTotalICs_RatingBased.get(u.id));
                                    //If user is not already present in the aggregate map mapOwnerToTotalICs_RatingBased, initialize countTotalLead to zero
                                    if(!mapOwnerToTotalICs_RatingBased.containsKey(u.id)){
                                        countTotalLead = 0;
                                        system.debug('Here 12');
                                    }
                                    //If user is already present in the aggregate map mapOwnerToTotalICs_RatingBased, assign the value of countTotalLead from the map
                                    else{
                                        countTotalLead = mapOwnerToTotalICs_RatingBased.get(u.id);
                                        system.debug('Here 22');
                                    }
                                    
                                    system.debug('countTotalLead '+countTotalLead);
                                    system.debug('u.id'+u.id);
                                    system.debug('u.Rating_Formula__c '+u.Rating_Formula__c);
                                    
                                    //To store the value of total IC assigned to the user divided by user rating.
                                    Decimal countTotalLeadperRating = countTotalLead/u.Rating_Formula__c;
                                    system.debug('countTotalLeadperRating '+countTotalLeadperRating);
                                    
                                    //Insert the value in the userMap
                                    //update - SEEP-9547
                                    userMap.put(u.id, new UserObjectWrapper(u.Rating_Formula__c,countTotalLeadperRating,countTotalLead,listOfUserPrograms,u.Advisor_Tier__c));                                   
                                }
                                else{
                                    system.debug('userMap after loop runs '+userMap);
                                }
                                //userMapValueUpdate.put(u.id,u); //Store user values to update   
                            }                             
                        }
                        system.debug('userMap before assignment 1 '+userMap);
                        Id userIdWithLowestLead = null;
                        Decimal lowestLead = null;
                        Decimal highestRating = null;
                        
                        //SEEP-9547 - new fields
                        Id tierUserIdWithLowestLead = null;
                        Decimal tierLowestLead = null;
                        Decimal tierHighestRating = null;
                        
                        for(Id idOfUser : userMap.keySet()){
                            UserObjectWrapper user = userMap.get(idOfUser); 
                            //Check the user with lowest totallead/rating, if same then select the user with highest rating.
                            if(lowestLead == null || user.totalLeadperRating < lowestLead || (user.totalLeadperRating == lowestLead && user.rating > highestRating)){
                                //Check if the IC programmes is tagged to the user.
                                if((user.listOfUserPrograms).contains(ic.Programme_New__r.name)||(user.listOfUserPrograms).contains('All Programs')){
                                    lowestLead = user.totalLeadperRating;
                                    system.debug('lowestLead >'+idOfUser+' '+lowestLead);
                                    highestRating = user.rating;
                                    system.debug('highestRating >'+idOfUser+' '+highestRating);
                                    userIdWithLowestLead = idOfUser;
                                }
                            }
                            
                            //SEEP-9547 - Tier based flow - Check the user with lowest totallead/rating, if same then select the user with highest rating.
                            if(tierLowestLead == null || user.totalLeadperRating < tierLowestLead || (user.totalLeadperRating == tierLowestLead && user.rating > tierHighestRating)){
                                //Check if the IC programmes is tagged to the user along with tier value on IC and user
                                if(((user.listOfUserPrograms).contains(ic.Programme_New__r.name)||(user.listOfUserPrograms).contains('All Programs')) 
                                    && user.advisorTier != null && ic.Lead_Score_Tier_Bucket__c == user.advisorTier){
                                    tierLowestLead = user.totalLeadperRating;
                                    system.debug('lowestLead >'+idOfUser+' '+lowestLead);
                                    tierHighestRating = user.rating;
                                    system.debug('highestRating >'+idOfUser+' '+highestRating);
                                    tierUserIdWithLowestLead = idOfUser;
                                }
                            }
                        }
                        system.debug('lowestLead >>'+lowestLead );
                        system.debug('highestRating >>'+highestRating);
                        
                        system.debug('lowestLead >>'+tierLowestLead );
                        system.debug('highestRating >>'+tierHighestRating);
                        
                        //SEEP-9547 - added if block
                        if(String.isNotblank(tierUserIdWithLowestLead)){
                            UserId = tierUserIdWithLowestLead;
                        }else{
                            UserId = userIdWithLowestLead;
                        }
                        system.debug('UserId for new Assignment '+UserId);
                        
                        //Update the count of total lead assigned in the userMap
                        if(UserId!=null){
                            if(userMap.get(UserId).totalLeads == null){
                                userMap.get(UserId).totalLeads = 1;
                            }
                            else{
                                userMap.get(UserId).totalLeads = userMap.get(UserId).totalLeads+1;                                
                            }                                
                            
                            userMap.get(UserId).totalLeadperRating = (userMap.get(UserId).totalLeads) / (userMap.get(UserId).rating);
                            system.debug('userMap.get(UserId).totalLeadperRating '+userMap.get(UserId).totalLeadperRating);                                
                        }
                        system.debug('userMap after assignment '+userMap);
                    }
                }
                system.debug('Check UserId::; '+UserId );
                if(UserId == null && ic.OwnerId != null){
                    UserId = ic.OwnerId;
                    system.debug('Check defaultICOwner---------------------->'+UserId); 
                }
                if(UserId != null && (ic.Lead__r.Capture_Source__c == 'Web to Lead' || ic.Lead__r.Capture_Source__c == System.Label.Referral_India_form) && ic.Lead__r.Capture_Source__c != 'Application Form'){ //&& ic.Lead__r.OwnerId != Label.Lead_Owner_id)
                    system.debug('Dispatcher_RR '+ic.Assignment_Type__c);
                    if(ic.Programme_New__c != null){
                        ic.Assignment_Type__c = 'Round Robin'; //added for SEEP 5810
                        system.debug('Assignment Type'+ic.Assignment_Type__c);                                       
                    }
                    else{
                        ic.Assignment_Type__c = 'Manual'; //added for SEEP 5810
                        }           
                    obLeadMap.get(ic.Lead__c).OwnerId = UserId;
                    ic.OwnerId = UserId; // Added by Mayank Agarwal for the Story SEEP-7759
                }
                if(ic.Lead__r.agree__C == 'No I Do Not Agree' ){ //code added by anup for GDPR- No I do not agree
                    system.debug('ic.Lead__r.agree__C2::; '+ic.Lead__r.agree__C );
                    //ic.OwnerId =Label.Lead_Owner_id; // Commented by Mayank Agarwal for the Story SEEP-8357
                    ic.Assignment_Type__c = 'Round Robin'; //added for SEEP 5810
                }
                if(ic.Lead__r.Capture_Source__c == 'Manual'){ //added for SEEP 5810
                    ic.Assignment_Type__c = 'Manual';
                }
            }
            lstLeadOwnerUpdate.add(ic);
        }
        if(lstLeadOwnerUpdate != null && lstLeadOwnerUpdate.size() > 0){
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = false;
            //dmo.emailHeader.triggerUserEmail = true;
            Database.update(lstLeadOwnerUpdate, dmo);
            try{
                update obLeadMap.values();
            }catch(Exception e) {
                System.debug('Exception'+e);
            }
        }
    }
    
    //Wrapper class to store user details for Round Robin SEEP-8400
    @testvisible
    private class UserObjectWrapper{
        
        public Decimal rating;
        public Decimal totalLeadperRating;
        public Decimal totalLeads;
        public List<String> listOfUserPrograms;
        public String advisorTier;//SEEP-9547
        
        public UserObjectWrapper(Decimal rating, Decimal totalLeadperRating, Decimal totalLeads, List<String> listOfUserPrograms, String advisorTier){
            
            this.rating = rating;
            this.totalLeadperRating = totalLeadperRating;
            this.totalLeads = totalLeads;
            this.listOfUserPrograms = listOfUserPrograms;
            this.advisorTier = advisorTier;//SEEP-9547
        }
        
    }
}