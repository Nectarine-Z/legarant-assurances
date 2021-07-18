@RestResource(urlMapping = '/Contracts/*')

global with sharing class P12Contrats{
    @HttpPost
    global static ID createContrat(String accountId,Date startDate,Integer contractTerm, String status){
        Contract thisContract = new Contract(
            AccountId = accountId, 
            StartDate = startDate, 
            ContractTerm = contractTerm, 
            Status = status);
        insert thisContract;
        return thisContract.id;
    }
    
    @HttpPatch
	global static ID updateContRactFields(){
		RestRequest request = RestContext.request;
		String ContractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
		system.debug('id from posstman ==>'+request.requestURI.substring(request.requestURI.lastIndexOf('/')+1));
		Contract thisContract = [SELECT Id,contractTerm
		                       FROM Contract
		                       WHERE Id = :ContractId];

		system.debug('Contract'+thisContract);
		// Deserialize the JSON string into name-value pairs
		Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        system.debug('contraaaaaat '+ params);
		// Iterate through each parameter field and value
		for (String fieldName : params.keySet()){
			// Set the field and value on the Contact sObject
			thisContract.put(fieldName, params.get(fieldName));
		}
		update thisContract;
		return thisContract.Id;
	}
    /*@HttpPatch
    global static ID updateContractFields(){
        RestRequest request = RestContext.request;
        system.debug('essaiiiii'+ request);
        Map<String, String> paramsMap = RestContext.request.params;
        //recuperer le contactId passé en paramètre
        String accountId  = paramsMap.get('accountId');
        String contratId  = paramsMap.get('contratId');
        Integer contractTerm   = Integer.valueOf(paramsMap.get('contractTerm'));
        
        //String ContratId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contract thisContract = [SELECT Id,AccountId,startDate,ContractTerm,Status FROM Contract
                                 WHERE Id = :ContratId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        system.debug(request.requestbody.tostring() );
        // Iterate through each parameter field and value
        for (String fieldName : m.keySet()){
            // Set the field and value on the Contract sObject
            
            thisContract.put(fieldName, m.get(fieldName));
        }
        update thisContract;
        return thisContract.Id;
        
    }*/
    
}