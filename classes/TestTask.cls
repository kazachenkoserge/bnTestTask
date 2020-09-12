public with sharing class TestTask {
public TestTask() {

}
/**
 * Because i didnt recieved use case description on Friday, and had deadline on Monday, i decide to implement something, 
 * what,at least, can be used as a starting point for task, which was described in very general to me.
 * Obviously, this will not work by its own. I even dont have credentials for this Channel Rush service and im not sure
 * if credentials for Inventory will do this job.
 * @param reservation Resrevation__c object
 * @returns `Integer` Http response code
 */
public Integer ariUpdate(Reservation__c reservation) {
	if (reservation.Room_Type_Lookup__c!=null) {
		List<Room_Type__c> roomType = [SELECT Id, Room_Type_Code__c FROM Room_Type__c WHERE Id=:reservation.Room_Type_lookup__c];
		if (!roomType.isEmpty()) {
			if (roomType[0].Room_Type_Code__c!=null) {
				try {
					// will not work, obviously, because this API on another endpoint
					// so another record with correct endpoint should be added to custom settings first
					String endpoint = Configuration.getValue('ChannelRush Inventory ENDPOINT');
					String username = Configuration.getValue('ChannelRush userName');
					String password = Configuration.getValue('ChannelRush password');
					HTTP h = new HTTP();
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(endpoint);
                    request.setMethod('POST');
                    request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
                    Map<String, Object> body = new Map<String, Object>();
                    body.put('propertyId', reservation.Property_ID__c);//not sure is this a right choice.
                    Map<String, Object> item = new Map<String, Object>();
                    item.put('roomTypeId', roomType[0].Room_Type_Code__c);
                    item.put('dateRange', '{"endDate":"2025-01-28", "startDate":"2025-01-01"}'); //just because its required
                    body.put('items', new List<String>{JSON.serialize(item)});
                    request.setBody(JSON.serialize(body));
                    HttpResponse response = h.send(request);
                    if (response.getStatusCode()==200) {
                        //do something
                        return response.getStatusCode();
                    } else switch on response.getStatusCode() {
                        when 400 {
                            //panic();
                        }
                        when else {
                            //panic();
                        }
                    }
				} catch (Exception e) {
                    System.debug('Exception in TestTask.ariUpdate');
                    System.debug(e.getMessage());
                    System.debug(e.getLineNumber());
				}
			}
		}


    } 
    return null;
}
}
