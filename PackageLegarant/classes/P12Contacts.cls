@RestResource(urlMapping='/Contacts/*')
global with sharing class P12Contacts {
    @HttpGet
    global static Contact getRecordById() {
        RestRequest request = RestContext.request;
        
        // grab the recordId from the end of the URL
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact result =  [SELECT Id,Name,Email FROM Contact WHERE Id = :contactId];               
        return result;
        
    } 
    @HttpPost
    global static String createContact() {
       Contact thisContact = new Contact(); //new Contact(Phone=phone, firstName=firstName, lastName=lastName, Email=email);
        ID id;
        RestRequest request = RestContext.request;
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        system.debug('nammmess '+ params);
        String email, message, phone,firstName,lastName;
		// Iterate through each parameter field and value
		for (String fieldName : params.keySet()){
            if (fieldName == 'Email'){
                 email = params.get(fieldName).tostring();
            }
            if (fieldName == 'lastName'){
                 lastName = params.get(fieldName).tostring();
           
            }
            if (fieldName == 'firstName'){
                 firstName = params.get(fieldName).tostring();
			//thisContact.put(fieldName, params.get(fieldName));
		}
            if (fieldName == 'phone'){
                 phone = params.get(fieldName).tostring();
			//thisContact.put(fieldName, params.get(fieldName));
		}
            
        }   
        system.debug('emailll '+ email);
        List<Contact> contactByEmail =  [SELECT Id,Name,Email FROM Contact WHERE Email =: email]; 
        system.debug('dheuhfifez'+ contactByEmail);
        if(!contactByEmail.isEmpty()){
            id = contactByEmail.get(0).Id;
            message = 'cet email existe déjà '+ id;
        }
        else {
            thisContact.firstName= firstName;
            thisContact.lastName= lastName;
            thisContact.email= email;
            thisContact.phone= phone;
            insert thisContact;
            id = thisContact.Id;  
            message = 'email crée avec succès '+ id;
        } 
        return message;
    }
    /*@HttpPost
	global static String createContact(String firstName, String lastName, String email, String phone){
        system.debug('dejzfbrzefblfhribdsk');
		Contact thisContact = new Contact(FirstName = firstName, LastName = lastName, Email = email, Phone = phone);
	    Contact cs  =  new Contact();
        String message;
		Boolean check = GestionDesContacts.contactEmailExist(thisContact.email);
        // si pas d'insertion renvoie un id null 
		if (check){
			cs = [select Id,Name,phone,email from contact where email =:email limit 1];
            message = 'cet email existe déjà '+ cs.id;
            //system.debug('ids ==>'+ids);
		}
        else {
            cs = thisContact;
            insert cs;
            system.debug('Contact posted Id ==>'+cs.Id);
            //insert thisContact;
            message = 'email crée avec succès '+  cs.Id;
        }
       return message;
	}*/

    
    
    @HttpDelete
    
    global static String desactivateContact(){
        
        RestRequest request = RestContext.request;
        // recuperer la requête passée depuis Postman en même temps que les paramètres
        Map<String, String> paramsMap = RestContext.request.params;
        //recuperer le contactId passé en paramètre
        String ContactId = paramsMap.get('ContactId');
        
        system.debug('id :' + ContactId);
        //String ContactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        system.debug('*ca marche !' + contactId);
        if (contactId == null) {
            return 'passer le contact Id en paramètre ';
        }
        // Récupération du contact à mettre à jour
        Contact thisContact = [SELECT Id, Desactivated__c FROM Contact WHERE Id = :ContactId];
        // custom field checkbox desactivate__c créée dans l'org
        if (thisContact != null){
            thisContact.Desactivated__c = true;
            update thisContact;
        }
        thisContact.Desactivated__c = true;
        update thisContact;
        return 'Le contact a été désactivé !';
    }
    @HttpPatch
	global static ID updateContactFields(){
		RestRequest request = RestContext.request;
		String ContactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
		system.debug('id from posstman ==>'+request.requestURI.substring(request.requestURI.lastIndexOf('/')+1));
		Contact thisContact = [SELECT Id,Name,Email
		                       FROM Contact
		                       WHERE Id = :ContactId];

		system.debug('Contact'+thisContact);
		// Deserialize the JSON string into name-value pairs
		Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        system.debug('nammmess '+ params);
		// Iterate through each parameter field and value
		for (String fieldName : params.keySet()){
			// Set the field and value on the Contact sObject
			thisContact.put(fieldName, params.get(fieldName));
		}
		update thisContact;
		return thisContact.Id;
	}
    /*@HttpPatch 
    //winter21 : new : To make partial or full updates to a resource in an HTTP web service,
    //specify the PATCH method in the HttpRequest class.
    global static ID updateContactFields(){
        RestRequest request = RestContext.request;
        String ContactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :ContactId];
        
        //the JSON string input request doit être changé 
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for (String fieldName : m.keySet()){
            // Set the field and value on the Contact sObject
            thisContact.put(fieldName, m.get(fieldName));
        }
        update thisContact;
        return thisContact.Id;
    }*/
}