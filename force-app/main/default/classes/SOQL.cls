/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author McKay Howell
 */

public with sharing class SOQL {
	/**
	 * Question 1
	 * Update/Uncomment the template code to create a method
	 * Returns all leads from Salesforce Org
	 * @return List of all leads with Id, LastName, Company, Phone, Email
	 * Update the corresponding test class and testGetAllLeads method to cover this method
	 */
	public static List<Lead> getAllLeads() {
	  List<Lead> leads = [SELECT Id, LastName, Company, Phone, Email FROM Lead];
	  return leads;
	}

	/**
	 * Question 2
	 * Update/Uncomment the template code to create a method
	 * Returns all contacts with first name of John.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByFirstName method to cover this method
	 */
	public static List<Contact> getContactsByFirstName(String firstName) {
	  List<Contact> contacts = [SELECT Id, Name, FirstName, LastName FROM Contact WHERE FirstName = :firstName];
	  return contacts;
	}

	/**
	 * Question 3
	 * Update/Uncomment the template code to create a method
	 * Returns the Contact Id for all contacts with last name of Smith or Jones
	 * @return A list of Contact Ids.
	 * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
	 */
	public static List<Id> getContactsByLastName(List<String> lastNames) {
	  List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName IN :lastNames];
	  Map<Id, Contact> contactsMap = new Map<Id, Contact>(contacts);
	  List<Id> contactIds = new List<Id>(contactsMap.keySet());
	  return contactIds;
	}

	/**
	 * Question 4
	 * Update/Uncomment the template code to create a method
	 * Returns List of closed won opportunities for a specific Account.
	 * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Opportunities with important opportunities fields
	 * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
	 */
	public static List<Opportunity> getClosedWonOpportunityCountByAccount(Id accountId){
		List<Opportunity> opps = [SELECT Id, Name, StageName, AccountId, CloseDate, Amount 
								FROM Opportunity 
								WHERE AccountId = :accountId AND StageName = 'Closed Won'];
		return opps;
	}

	/**
	 * Question 5
	 * Update/Uncomment the template code to create a method
	 * Returns the total count of Account records.
	 * @return The Integer count of Account records.
	 * Update the corresponding test class and testGetAccountCount method to cover this method
	 */
	public static Integer getAccountCount(){
		// Queries with aggregate functions return results in AggregateResult
		// https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_SOQL_agg_fns.htm
		AggregateResult queryResult = [SELECT COUNT(Id) numAccounts FROM Account];
		Integer count = (Integer) queryResult.get('numAccounts');
		return count;
	}

	/**
	 * Question 6
	 * Update/Uncomment the template code to create a method
	 * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
	 * @return A map of Task Ids to Task records.
	 * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
	 */
	public static Map<Id, Task> getTasksDueNextWeek(){
		// SOQL date literals: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql_select_dateformats.htm
		Map<Id, Task> taskMap = new Map<Id,Task>([SELECT Id FROM Task WHERE ActivityDate = NEXT_N_DAYS:7]);
		return taskMap;
	}

	/**
	 * Question 7
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Contacts that have a example.com domain in their Email.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
	 */
	public static List<Contact> getContactsByEmailDomain(String domain){
		String domainCriteria = '%' + domain;
		List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE Email LIKE :domainCriteria];
		return contacts;
	}

	/**
	 * Question 8
	 * Retrieves all Opportunities that have a specific keyword in their Name.
	 * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
	 * @param keyword The keyword to search for in the Opportunity Name.
	 * @return A list of Opportunity records.
	 */
	public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
		String keywordCriteria = '%' + keyword + '%';
		List<Opportunity> opps = [SELECT Id, Name FROM Opportunity WHERE Name LIKE :keywordCriteria];
		return opps; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 9
	 * Retrieves all Cases that Case Origin is not Web or Email or Blank
	 * @return A list of Case records.
	 */
	public static List<Case> getFilterCaseOrigins() {
		List<Case> cases = [SELECT Id, Subject, Origin FROM Case WHERE Origin NOT IN ('Web', 'Email', '')];
		return cases; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 10
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
	 * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
	 * @param leadSource The Lead Source to search for.
	 * @param keyword The keyword to search for in the Lead Title.
	 * @return A list of Lead records.
	 * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
	 */
	public static List<Lead> getLeadsBySourceOrTitle(String sourceKeyword, String titleKeyword){
		String sourceCriteria = '%' + sourceKeyword + '%';
		String titleCriteria = '%' + titleKeyword + '%';
		List<Lead> leads = [SELECT Id, LastName, Company, Phone, Email FROM Lead WHERE LeadSource LIKE :sourceCriteria OR Title LIKE :titleCriteria];
		return leads;
	}

	/**
	 * Question 11
	 * Returns the names of all Contacts associated with an Account.
	 * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Contact LastName.
	 */
	public static List<String> getContactNamesByAccount(Id accountId) {
		// Create a list to hold the Contact LastNames
		List<String> contactLastNames = new List<String>();

		// Query the Contacts
		List<Contact> contacts = [SELECT Id, LastName FROM Contact WHERE AccountId = :accountId];

		// Loop through each Contact and add the LastName to the list
		for (Contact c : contacts){
			contactLastNames.add(c.LastName);
		}

		// Return the list of Contact LastNames
		return contactLastNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 12
	 * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
	 * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
	 * @param stage The Stage value to filter Opportunities.
	 * @return The total revenue.
	 */
	public static Decimal getTotalRevenueByStage(String stage) {
		// Use AggregateQuery to get the total revenue
		AggregateResult revenueResult = [SELECT SUM(Amount) revenue FROM Opportunity WHERE StageName = :stage OR Amount > 10000];
		Decimal revenue = (Decimal) revenueResult.get('revenue');

		// Return the total revenue
		return revenue; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 13
	 * Retrieves the first 10 Accounts ordered by Name.
	 * @return A list of the first 10 Accounts ordered by Name.
	 */
	public static List<Account> getFirstTenAccounts() {
		List<Account> accounts = [SELECT Id, Name FROM Account ORDER BY Name LIMIT 10];
		return accounts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 14
	 * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 */
	public static List<Opportunity> getHighValueOpportunities() {
		List<Opportunity> opps = [SELECT Amount, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate LIMIT 5];
		return opps; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 15
	 * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
	 * @return A list of Contacts
	 */
	public static List<Contact> getBirthdateContacts() {
		List<Contact> contacts = [SELECT Birthdate FROM Contact ORDER BY Birthdate DESC LIMIT 3];
		return contacts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 16
	 * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
	 * @return A list of Cases
	 */
	public static List<Case> getCasesWithStatus() {
		List<Case> cases = [SELECT Id, CreatedDate FROM Case WHERE Status = 'Open' ORDER BY CreatedDate LIMIT 10 OFFSET 5];
		return cases; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 17
	 * Returns Set of Case Ids for a specific Account.
	 * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A set of Case Ids.
	 */
	public static Set<Id> getCaseIdsByAccount(Id accountId) {
		// Create a set to hold the Case Ids
		Set<Id> caseIds = new Set<Id>();

		// Query the Cases
		List<Case> cases = [SELECT Id FROM Case WHERE AccountId = :accountId];

		// Loop through each Case and add the Id to the set
		for (Case c : cases){
			caseIds.add(c.Id);
		}

		return caseIds; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 18
	 * Return Map of Account Ids to Account Names Not in a specific Country.
	 * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
	 * @param country The country to filter Accounts.
	 * @return A map of Account Ids to Account Names.
	 */
	public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
		// Create a map to hold the Account Ids to Account Names
		Map<Id, String> accountIdsToNames = new Map<Id, String>();

		// Query the Accounts
		List<Account> accounts = [SELECT Id, Name FROM Account WHERE BillingCountry != :country];

		// Loop through each Account and add the Id and Name to the map
		for (Account a : accounts){
			accountIdsToNames.put(a.Id, a.Name);
		}

		return accountIdsToNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 19
	 * Retrieves the Account Name for a given Contact.
	 * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
	 * @param contactId The Id of the Contact.
	 * @return The Account Name of the Contact.
	 */
	public static String getAccountNameForContact(String contactId) {
		// Replace null with the variable you used to store the result
		return [SELECT Account.Name FROM Contact WHERE Id = :contactId LIMIT 1].Account.Name;
	}

	/**
	 * Question 20
	 * Returns single Account that has related opportunities in the same query
	 * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
	 * @param accountId The ID of the Account.
	 * @return An Account record with related Opportunities.
	 */
	public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
		Account acctWithOpps = [SELECT Id, Name, (SELECT Name FROM Opportunities) FROM Account WHERE Id = :accountId];
		return acctWithOpps; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 21
	 * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
	 * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
	 * @param Account Id
	 * @return List of contacts with the same Mailing State as the Account Billing State
	 */
	public static List<Contact> getAccountsWithContactsByState(Id accountId) {
		// Query the Account
		Account acct = [SELECT BillingState FROM Account WHERE Id = :accountId];

		// Store the Account's BillingState
		String billingState = acct.BillingState;

		// Query the Contacts
		List<Contact> contacts = [SELECT Id FROM Contact WHERE MailingState = :billingState];
		return contacts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 22
	 * Extracts email domains from them leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = www.test.com
	 * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param A set of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 */
	public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
		// Query the Leads
		List<Lead> leads = [SELECT Id, Email FROM Lead WHERE Id IN :leadIds];

		// Create a set of email domains from the Leads
		Set<String> websites = new Set<String>();

		// Loop through each Lead
		for(Lead loopLead : leads){
			if(!String.isBlank(loopLead.Email)){
				// Add the email domain to the set
				String website = 'www.' + loopLead.Email.substringAfter('@');
				websites.add(website);
			}
		}

		// Query the Accounts
		List<Account> accounts = [SELECT Id, Website FROM Account WHERE Website IN :websites];

		return accounts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 23
	 * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
	 * Adds a randomized number between 1 to 3 to the quantity of each line item.
	 * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
	 * @param Original Opportunity Id
	 * @param List of cloned Opportunity Ids
	 */
	public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
		// Query the original Opportunity Line Items
		List<OpportunityLineItem> origItems = [SELECT Id, Quantity, UnitPrice, PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId = :origOppId];

		// Create a list to hold the new line items
		List<OpportunityLineItem> cloneItems = new List<OpportunityLineItem>();

		// Generate a random number between 1 and 3
		Double seed = Math.random(); // returns a number between 0 and 1
        Double randomDouble = 1 + (seed * 2);
        Integer randomInt = Math.rint(randomDouble).intValue(); // chooses the mathematically closest integer to the random double number


		// Loop through each cloned Opportunity Id
		for (Id cloneOppId : cloneOppIds){
			// Loop through each original line item
			for (OpportunityLineItem origItem : origItems){
				// Clone the original line item and add the random number to the quantity
				OpportunityLineItem cloneItem = origItem.clone(false, false, false, false);
				cloneItem.OpportunityId = cloneOppId;
				cloneItem.Quantity += randomInt;

				// Add to the list
				cloneItems.add(cloneItem);
			}
		}

		// Insert the new line items
		insert cloneItems;
	}

	/**
	 * Question 24
	 * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
	 * @return A list of filtered Opportunity
	 */
	public static List<Opportunity> getOpportunityDetailsForClosedWon() {
		List<Opportunity> opps = [SELECT Name, Account.Name, Owner.Name FROM Opportunity WHERE StageName = 'Closed Won'];
		return opps; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 25
	 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
	 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby."
	 */
	public static void setPrimaryContact() {
		//Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
		List<Opportunity> closedOpps = [SELECT AccountId FROM Opportunity WHERE StageName = 'Closed Won'];

		// Create a set of Account Ids from the Opportunities
		Set<Id> acctIds = new Set<Id>();
		for (Opportunity opp : closedOpps){
			acctIds.add(opp.AccountId);
		}

		// Query the Contacts
		// IMPORTANT: these must be ordered by FirstName in DESCENDING order so that the alphabetically first item will be the last one processed in the loop
		List<Contact> contacts = [SELECT Id, AccountId, FirstName FROM Contact WHERE AccountId IN :acctIds ORDER BY AccountId, FirstName DESC];

		// Loop through each Contact and add the Account Id and Contact to the map
		Map<Id,Id> accountToContactMap = new Map<Id,Id>();
		for(Contact con : contacts){
			accountToContactMap.put(con.AccountId, con.Id);
		}

		// Loop through each Opportunity
		for(Opportunity opp : closedOpps){
			// Update the Opportunity primary contact from accountToContactMap
			opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId);
		}

		// Update the Opportunities
		update closedOpps;
	}


	/**
	 * March 23, 2026 - Breakout Room Student Solution:  
	 * Given a list of Account industries, create a new Opportunity for each account in that industry that has less than 2 open Opportunities
	 * @return number of new Opportunities created
	 */
	public static Integer createIndustryOpps(List<String> industries){
		// Write a method that takes in a list of strings.
		// Search for all accounts where Account.Industry matches any of the input strings.
		List<Account> accts = [SELECT Id, (SELECT Id, AccountId FROM Opportunities WHERE StageName != 'Closed Won' AND StageName != 'Closed Lost') 
							FROM Account 
							WHERE Industry IN :industries];
		
		// For each of these accounts, determine if they have at least two open opportunities.
		Map<Id, Integer> acctIdToNumOpps = new Map<Id,Integer>();
		for(Account acct : accts){
			Integer acctOppCount = 0;
			for (Opportunity opp : acct.Opportunities){
				acctOppCount += 1;
			}
			acctIdToNumOpps.put(acct.Id, acctOppCount);
		}

		// If they do not, create one new opportunity.
		List<Opportunity> oppsToCreate = new List<Opportunity>();
		for(Id acctId : acctIdToNumOpps.keySet()){
			Boolean lessThan2 = acctIdToNumOpps.get(acctId) < 2;
			if(lessThan2){
				Opportunity opp = new Opportunity();
				opp.AccountId = acctId;
				opp.Name = 'Test Opp ' + acctId;
				opp.CloseDate = Date.today() + 7;
				opp.StageName = 'Prospecting';
				oppsToCreate.add(opp);
			}
		}
		insert oppsToCreate;
		System.debug('Inserted new opps: ' + oppsToCreate.size());

		//Return the number of opportunities created
		return oppsToCreate.size();

	}

	/**
	 * March 23, 2026 - Instructor Solution  
	 * Given a list of Account industries, create a new Opportunity for each account in that industry that has less than 2 open Opportunities
	 * @return number of new Opportunities created
	 */
	public static Integer oppIndustryQuery(List<String> industries)
    {
        Map<Id,Account> accountsByIndustry = new map<Id, Account>([SELECT id FROM Account WHERE Industry IN :industries]);
        AggregateResult[] oppCounts = [SELECT accountId, count(id) FROM Opportunity WHERE AccountId IN :accountsByIndustry.keySet() AND IsClosed = false GROUP BY accountId];
        Map<Id, Integer> oppsByAccountId = new Map<Id, Integer>();
        for(AggregateResult ar : oppCounts)
        {
            oppsByAccountId.put((Id)ar.get('accountId'), (Integer)ar.get('expr0'));            
        }

        List<Opportunity> newOpps = new List<Opportunity>();
        for (Id a : accountsByIndustry.keySet())
        {
            Integer oppCount = oppsByAccountId.get(a);
            if(oppCount == null || oppCount < 2)
            {
                newOpps.add(createOpp(a));
            }
        }

        insert newOpps;
        return newOpps.size();
    }

    private static Opportunity createOpp(Id a)
    {
        Opportunity o = new Opportunity();
        o.Name = 'March 23';
        o.AccountId = a;
        o.CloseDate = date.today();
        o.StageName = 'Prospecting';
        return o;
    }


	/**
	 * April 7, 2026 - HW Feedback challenge
	 * Try writing a query that uses a subquery to find all Accounts that have at least one Contact but zero Opportunities. 
	 * It's great practice for using NOT IN with subqueries!
	 * @return collection of identified Accounts
	 */
	public static List<Account> acctContactsNoOppsQuery(){
		List<Account> accts = [SELECT Id FROM Account 
								WHERE Id IN (SELECT AccountId FROM Contact WHERE AccountId != null) 
								AND Id NOT IN (SELECT AccountId FROM Opportunity WHERE AccountId != null)];
		return accts;
	}
}
