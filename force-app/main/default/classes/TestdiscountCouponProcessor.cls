/********************************************************************
* Class: TestdiscountCouponProcessor
* Author:
* Description: This is the test class of below classes:
                1. discountCouponProcessor
                2. discountCouponProcessorUtil
                3. discountCouponTrigger
                4. discountCouponTriggerHandler
                5. discountCouponWrapper

* Date: 01/02/2025 // Test comment to check DevOps
* ******************************************************************/
@isTest
public class TestdiscountCouponProcessor {
    
    public Static List<String> recordTypeName = new List<String>{'Discount Coupon','MasterDiscountCoupon'};
    public Static Map<String,ID> mapRecordTypeName_ID= new Map<String,ID>();
    public Static List<RecordType> listRecordType = new List<RecordType>();
    public static String discountCoupon = 'Discount Coupon';
    public static String masterDiscountCoupon = 'MasterDiscountCoupon'; 
    Public static String todaysDate = String.valueOf(System.today());
    Public static String endDate = String.valueOf(System.today() + 1);
    
    Static{
        //fetch the product recordtype data
        listRecordType = [Select id,Name from RecordType where name IN : recordTypeName];
        if(listRecordType.size()>0){
            for(RecordType objRecordType : listRecordType){
                mapRecordTypeName_ID.put(objRecordType.Name,objRecordType.Id);    //Put RecordType Name and id in Map
            }
        }
    }
    //this covers code of number of tution assistence 1.
    public static testMethod void testDiscountCoupon(){
        
        //Product record insert
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.recordTypeId = mapRecordTypeName_ID.get(masterDiscountCoupon);
        prod.Handled_By__c = 'Emeritus';
        prod.Coupon_Name__c = 'XYZ123';
        insert prod;
        
        //request/response varibales
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        //JSON String
        String jsonTokenResponse = '{"Stacking": true,"Handled_By": "'+prod.Handled_By__c+'","TuitionAssistanceName": "Test01022025","NoofTuitionAssistance": "2","NoofUses": "2","StartDate": "'+todaysDate+'","EndDate": "'+endDate+'","TuitionAssistanceType": "Flat Discount","Amount": "123.23","DiscountCategory": "Alum","Programs": ["'+prod.ID+'"]}';
        
        req.requestBody = Blob.valueof(jsonTokenResponse);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        //API method Call for success
        DiscountCouponProcessor.postCouponManagement();

        //API method Call for Failure
        DiscountCouponProcessor.postCouponManagement();              
    }
    
    //this covers discount coupon creation/failure code.
    public static testMethod void testDiscountCoupon1(){
        
        //Product record insert
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.recordTypeId = mapRecordTypeName_ID.get(masterDiscountCoupon);
        prod.Handled_By__c = 'Emeritus';
        prod.Coupon_Name__c = 'XYZ123';
        insert prod;
        
        //request/response varibales
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        //JSON String
        String jsonTokenResponse = '{"Stacking": true,"Handled_By": "'+prod.Handled_By__c+'","TuitionAssistanceName": "Test010220251","NoofTuitionAssistance": "1","NoofUses": "2","StartDate": "'+todaysDate+'","EndDate": "'+endDate+'","TuitionAssistanceType": "Flat Discount","Amount": "123.23","DiscountCategory": "Alum","Programs": ["'+prod.ID+'"]}';
        
        req.requestBody = Blob.valueof(jsonTokenResponse);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        //API method Call for success
        DiscountCouponProcessor.postCouponManagement();
    }
    
    //This covers all validations
    public static testMethod void testDiscountCoupon2(){
        
        //Product record insert
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.recordTypeId = mapRecordTypeName_ID.get(masterDiscountCoupon);
        prod.Handled_By__c = 'Emeritus';
        prod.Coupon_Name__c = 'XYZ123';
        insert prod;
        
        //request/response varibales
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        //JSON String
        String jsonTokenResponse = '{"Stacking": true,"Handled_By": "'+prod.Handled_By__c+'","TuitionAssistanceName": "Test010220251","NoofTuitionAssistance": "1001","NoofUses": "2","StartDate": "'+String.valueOf(System.today() - 1)+'","EndDate": "'+String.valueOf(System.today() - 1)+'","TuitionAssistanceType": "Flat Discount","Amount": "123.23","DiscountCategory": "Alum","Programs": ["'+prod.ID+'"]}';
        
        req.requestBody = Blob.valueof(jsonTokenResponse);
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        //API method Call for success
        DiscountCouponProcessor.postCouponManagement();
    }
}