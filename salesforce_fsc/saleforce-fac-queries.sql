CREATE TABLE sf_fsc (id SERIAL PRIMARY KEY, doc_type text, doc jsonb);
INSERT INTO sf_fsc VALUES (DEFAULT, 'mortgage_loan',
$$
{
  "result" : {
    "accountId" : "001RM000004Xra2YAC",
    "assets" : [ ],
    "borrowers" : [ ],
    "createdById" : "005RM000001vbghYAA",
    "createdDate" : "2019-11-06T19:29:10.000Z",
    "extendedFields" : [ ],
    "externalId" : "tt2",
    "financials" : [ ],
    "hasOtherLoanFeature" : false,
    "hasPrepaymentPenalty" : false,
    "id" : "0cdRM00000000n5YAA",
    "isBalloon" : false,
    "isBorrowerInCommunityPropState" : false,
    "isConstructionToPermanent" : false,
    "isContractForDeed" : false,
    "isDeleted" : false,
    "isEnergyRelatedImprovement" : false,
    "isInterestOnly" : false,
    "isNegativeAmortization" : false,
    "isPropInCommunityPropState" : false,
    "isRenovation" : false,
    "isSingleClosing" : false,
    "isSubjectToPriorityLien" : false,
    "isTempIntRateBuydown" : false,
    "lastModifiedById" : "005RM000001vbghYAA",
    "lastModifiedDate" : "2019-11-06T19:31:07.000Z",
    "lastReferencedDate" : "2019-11-06T19:35:31.000Z",
    "lastViewedDate" : "2019-11-06T19:35:31.000Z",
    "liabilities" : [ ],
    "name" : "tt2",
    "ownerId" : "005RM000001vbghYAA",
    "properties" : [ ],
    "systemModstamp" : "2019-11-06T19:31:07.000Z",
    "titleHolders" : [ {
      "createdById" : "005RM000001vbghYAA",
      "createdDate" : "2019-11-06T19:29:10.000Z",
      "extendedFields" : [ ],
      "externalId" : "tt1",
      "id" : "0cTRM000000009e2AA",
      "isCurrentTitleHolder" : false,
      "isDeleted" : false,
      "lastModifiedById" : "005RM000001vbghYAA",
      "lastModifiedDate" : "2019-11-06T19:31:07.000Z",
      "lastReferencedDate" : "2019-11-06T19:31:07.000Z",
      "lastViewedDate" : "2019-11-06T19:31:07.000Z",
      "loanApplicationId" : "0cdRM00000000n5YAA",
      "name" : "tt2",
      "systemModstamp" : "2019-11-06T19:31:07.000Z"
    } ]
  }
}

$$);

INSERT INTO sf_fsc VALUES (DEFAULT, 'mortgage_loan_create',
$$
{
  "accountId": "001RM000004XraFYAS",
  "amortizationTerm": 30,
  "amortizationType": "Adjustable Rate",
  "assets": [
    {
      "accountNumber": "849393",
      "accountType": "Checking",
      "assetClass": "Financial",
      "assetType": "Earnest Money",
      "borrowersExternalIds": [
        "0fc5e4d6-de5d-4954-9d21-3c628ad8809a",
        "732c3d7e-78ae-4b5e-944d-f411fb4011d4"
      ],
      "cashOrMarketValue": 434934903,
      "dispositionType": "Pending Sale",
      "extendedFields": [],
      "externalId": "df126729-19c0-4dc9-80c6-322bc6fb994c",
      "financialInstitutionName": "BOFA",
      "grossMonthlyRentalIncome": 355395355,
      "name": "Asset1",
      "netMonthlyRentalIncome": 2535345,
      "presentMarketValue": 7937399,
      "realEstateAddress": {
        "city": "San Francisco",
        "country": "CA",
        "street": "234 1st Street"
      },
      "realEstateMonthlyExpense": 3413131
    },
    {
      "accountNumber": "2424242424",
      "accountType": "Checking",
      "assetClass": "Real Estate",
      "assetType": "Earnest Money",
      "borrowersExternalIds": [
        "0fc5e4d6-de5d-4954-9d21-3c628ad8809a",
        "732c3d7e-78ae-4b5e-944d-f411fb4011d4"
      ],
      "cashOrMarketValue": 24424525,
      "dispositionType": "Sold",
      "extendedFields": [],
      "externalId": "a57f5b81-477b-41a3-a647-5852562913e5",
      "financialInstitutionName": "wells",
      "grossMonthlyRentalIncome": 24242224,
      "name": "Asset2",
      "netMonthlyRentalIncome": 242424234,
      "presentMarketValue": 2423131313,
      "realEstateAddress": {
        "city": "San Francisco",
        "country": "CA",
        "street": "123 2nd Street"
      },
      "realEstateMonthlyExpense": 2242423424
    }
  ],
  "balloonTermMonths": 3,
  "borrowers": [
    {
      "addresses": [
        {
          "addressOwnership": "Own",
          "extendedFields": [],
          "externalId": "e8d51e2a-7d97-4da0-8356-ca86995d3d39",
          "monthlyRentPayment": 2300,
          "name": "Addr1",
          "residenceAdditionalMonthCount": 23,
          "residenceAddress": {
            "city": "San Francisco",
            "country": "United States",
            "postalCode": "94105",
            "state": "CA",
            "street": "50 Fremont Street"
          },
          "residenceYearCount": 3,
          "residencyType": "Former Residence"
        }
      ],
      "asianRaceSubType": "Asian Indian",
      "borrowerType": "Borrower",
      "citizenshipStatus": "U.S. Citizen",
      "declarations": [
        {
          "bankruptcyType": "Chapter 11",
          "borrowedAmount": 20000,
          "extendedFields": [],
          "externalId": "be71c372-8290-44dc-bb73-6f6d1ce7e9a9",
          "hasBorrowedMoney": true,
          "hasCoSignerUndisclosedDebt": true,
          "hasDeclaredBankruptcy": true,
          "hasDeedSurrender": true,
          "hasOutstandingJudgement": true,
          "hasOwnershipInterest": true,
          "hasPastShortSale": true,
          "hasPropertyForeclosed": true,
          "hasUndisclosedAddCreditApp": true,
          "hasUndisclosedOtherPropLoan": true,
          "isPartyToLawsuit": true,
          "isPresentlyDelinquent": true,
          "isPrimaryResidence": true,
          "isRelatedToSeller": true,
          "name": "Decl1",
          "priorPropertyTitleType": "Yourself",
          "priorPropertyUsageType": "Secondary Residence"
        }
      ],
      "dependentCount": 2,
      "dependentsAge": "25,34",
      "employments": [
        {
          "currentJobAdditionalMonthCount": 24,
          "currentJobYearCount": 4,
          "employerAddress": {
            "city": "Fresno",
            "country": "United States",
            "postalCode": "93721",
            "state": "CA",
            "street": "1500 Divisadero Street"
          },
          "extendedFields": [],
          "externalId": "2a9460d0-3194-449a-8bf0-488a6cbaed0a",
          "isRelToTransactionParty": true,
          "isLessThanQuarterShare": true,
          "isSelfEmployed": true,
          "jobTitle": "developer",
          "monthlyBaseIncomeAmount": 2300,
          "monthlyBonusAmount": 100,
          "monthlyCommissionAmount": 10,
          "monthlyIncome": 5000,
          "monthlyMilitaryEntitlementAmt": 20,
          "monthlyOtherIncomeAmount": 10,
          "monthlyOvertimeAmount": 200,
          "name": "Empl1",
          "startDate": "2019-10-10T03:11:27.000Z"
        }
      ],
      "ethnicitySubType": "Mexican",
      "ethnicityType": "Not Hispanic or Latino",
      "extendedFields": [],
      "externalId": "0fc5e4d6-de5d-4954-9d21-3c628ad8809a",
      "genderType": "Female",
      "hasMilitaryService": true,
      "incomes": [
        {
          "extendedFields": [],
          "externalId": "b19d9372-df99-4eec-9de0-ad785503992d",
          "incomeSourceType": "Capital Gains",
          "monthlyIncomeAmount": 100,
          "name": "Income1"
        }
      ],
      "isActiveMilitary": true,
      "isJointCredit": true,
      "isSurvivingMilitarySpouse": true,
      "maritalStatus": "Married",
      "militaryTourExpirationMonth": 2,
      "militaryTourExpirationYear": 2027,
      "name": "BR1",
      "otherAsianRaceSubType": "Indian",
      "otherEthnicitySubType": "Mexico",
      "otherPacIslandSubType": "Test Pacific Islander",
      "pacificIslanderSubType": "Native Hawaiian",
      "preferredLanguage": "English",
      "raceType": "Asian",
      "tribeName": "Pacific Islander",
      "wasActiveMilitary": true,
      "wasNonActivatedService": true
    },
    {
      "addresses": [
        {
          "addressOwnership": "Rent",
          "extendedFields": [],
          "externalId": "86c168dd-a29c-4c0b-b366-51a40cd66c4b",
          "monthlyRentPayment": 5000,
          "name": "Addr2",
          "residenceAdditionalMonthCount": 24,
          "residenceAddress": {
            "city": "San Francisco",
            "country": "United States",
            "postalCode": "94115",
            "state": "CA",
            "street": "1500 Divisadero Street"
          },
          "residenceYearCount": 3,
          "residencyType": "Present Address"
        }
      ],
      "asianRaceSubType": "Asian Indian",
      "borrowerType": "CoBorrower",
      "citizenshipStatus": "U.S. Citizen",
      "declarations": [
        {
          "bankruptcyType": "Chapter 12",
          "borrowedAmount": 657575,
          "extendedFields": [],
          "externalId": "704e7cfd-932c-4a17-81ad-844fe1a007c6",
          "hasBorrowedMoney": true,
          "hasCoSignerUndisclosedDebt": true,
          "hasDeclaredBankruptcy": true,
          "hasDeedSurrender": true,
          "hasOutstandingJudgement": true,
          "hasOwnershipInterest": true,
          "hasPastShortSale": true,
          "hasPropertyForeclosed": true,
          "hasUndisclosedAddCreditApp": true,
          "hasUndisclosedOtherPropLoan": true,
          "isPartyToLawsuit": true,
          "isPresentlyDelinquent": true,
          "isPrimaryResidence": true,
          "isRelatedToSeller": true,
          "name": "Decl1",
          "priorPropertyTitleType": "Yourself",
          "priorPropertyUsageType": "Primary Residence"
        }
      ],
      "dependentCount": 2,
      "dependentsAge": "34,35",
      "employments": [
        {
          "currentJobAdditionalMonthCount": 24,
          "currentJobYearCount": 3,
          "employerAddress": {
            "city": "Fresno",
            "country": "United States",
            "postalCode": "93721",
            "state": "CA",
            "street": "2300 Stockton Street"
          },
          "extendedFields": [],
          "externalId": "34380cb7-95ca-4867-9a74-972af1be22db",
          "isRelToTransactionParty": true,
          "isLessThanQuarterShare": true,
          "isSelfEmployed": true,
          "jobTitle": "developer",
          "monthlyBaseIncomeAmount": 2400,
          "monthlyBonusAmount": 234,
          "monthlyCommissionAmount": 10,
          "monthlyIncome": 45668,
          "monthlyMilitaryEntitlementAmt": 20,
          "monthlyOtherIncomeAmount": 394,
          "monthlyOvertimeAmount": 123,
          "name": "Empl2",
          "startDate": "2019-10-10T03:11:27.000Z"
        }
      ],
      "ethnicitySubType": "Mexican",
      "ethnicityType": "Hispanic or Latino",
      "extendedFields": [],
      "externalId": "732c3d7e-78ae-4b5e-944d-f411fb4011d4",
      "genderType": "Female",
      "hasMilitaryService": true,
      "incomes": [
        {
          "extendedFields": [],
          "externalId": "91027067-09d3-45f2-a0fc-217ce1f63458",
          "incomeSourceType": "Child Support",
          "monthlyIncomeAmount": 200,
          "name": "Income1"
        }
      ],
      "isActiveMilitary": true,
      "isJointCredit": true,
      "isSurvivingMilitarySpouse": true,
      "maritalStatus": "Married",
      "militaryTourExpirationMonth": 3,
      "militaryTourExpirationYear": 2029,
      "name": "COB1",
      "otherAsianRaceSubType": "South india",
      "otherEthnicitySubType": "Mexico",
      "otherPacIslandSubType": "Test pacific Islander",
      "pacificIslanderSubType": "Guamanian or Chamorro",
      "preferredLanguage": "English",
      "raceType": "American Indian or Alaska Native",
      "tribeName": "Pacific Islander",
      "wasActiveMilitary": true,
      "wasNonActivatedService": true
    }
  ],
  "estateHoldType": "Fee Simple",
  "extendedFields": [],
  "externalId": "0c4a3933-47d3-43d5-a2e6-09ae10e11a5e",
  "financials": [
    {
      "borrowerClosingCostAmt": 95956,
      "counselingAgencyProviderName": "Test provider",
      "counselingCompleteBorrName": "BR1",
      "counselingCompletionDate": "2019-10-31T19:00:00.000Z",
      "creditFromSeller": 33342,
      "discountPointCostAmount": 59586,
      "estFirstMortgagePayment": 459677,
      "estHomeownerInsurancePayment": 35521,
      "estMortgageInsurancePayment": 2424555,
      "estOtherDuesPayment": 24354,
      "estOtherPayment": 323231,
      "estPropertyTaxesPayment": 422556,
      "estSubordinateLienPayment": 35453,
      "estSuppPropInsurancePayment": 44959,
      "extendedFields": [],
      "externalId": "af7e7c76-33ac-4005-b377-4b4663a49ec9",
      "financeMortgageInsuranceAmt": 353,
      "hasCompletedCounseling": true,
      "hasHomeownerEducation": true,
      "homeEdCompletedBorrowerName": "BR1",
      "homeownerEdCompleteDate": "2019-10-24T19:00:00.000Z",
      "homeownerEdFormat": "Attended Workshop in Person",
      "housingCounselingFormat": "Face-to-Face",
      "hudApproveAgencyId": "12344",
      "hudApprovedProviderId": "3532",
      "landAcquiredSeparatelyAmount": 2040,
      "loanAmtExclFinMortgageInsurance": 33345,
      "name": "Fin1",
      "otherCredit": 2242,
      "otherNewMortgageLoanAmt": 253535,
      "outstandingLoanAmount": 24505056,
      "purchasePriceAmount": 150000,
      "remodelAndRepairsAmount": 3040
    }
  ],
  "hasOtherLoanFeature": true,
  "hasPrepaymentPenalty": true,
  "improvementCost": 100,
  "initialBuydownRate": 401,
  "interestOnlyMonthCount": 4,
  "interestRate": 4,
  "isBalloon": true,
  "isBorrowerInCommunityPropState": true,
  "isConstructionToPermanent": true,
  "isContractForDeed": true,
  "isEnergyRelatedImprovement": true,
  "isInterestOnly": true,
  "isNegativeAmortization": true,
  "isPropInCommunityPropState": true,
  "isRenovation": true,
  "isSingleClosing": true,
  "isSubjectToPriorityLien": true,
  "isTempIntRateBuydown": true,
  "leaseHoldExpirationDate": "2019-10-31T19:00:00.000Z",
  "liabilities": [
    {
      "accountNumber": "134234242",
      "accountType": "Revolving",
      "borrowersExternalIds": [
        "0fc5e4d6-de5d-4954-9d21-3c628ad8809a",
        "732c3d7e-78ae-4b5e-944d-f411fb4011d4"
      ],
      "creditLimitAmount": 34353,
      "creditorName": "BOFA",
      "extendedFields": [],
      "externalId": "df126729-19c0-4dc9-80c6-322bc6fb994c",
      "isJointLiability": true,
      "liabilityClass": "Financial",
      "loanType": "Conventional",
      "monthlyPaymentAmount": 35353,
      "name": "Liab1",
      "otherLiabilityType": "Child Support",
      "shouldBePaidInFull": true,
      "unpaidBalanceAmount": 242
    },
    {
      "accountNumber": "464634123",
      "accountType": "Revolving",
      "borrowersExternalIds": [
        "0fc5e4d6-de5d-4954-9d21-3c628ad8809a",
        "732c3d7e-78ae-4b5e-944d-f411fb4011d4"
      ],
      "creditLimitAmount": 423465356,
      "creditorName": "CHase",
      "extendedFields": [],
      "externalId": "194bcc9c-7b86-4a49-9d17-fad0e4d205a3",
      "isJointLiability": true,
      "liabilityClass": "Financial",
      "loanType": "Conventional",
      "monthlyPaymentAmount": 2423535,
      "name": "Liab2",
      "otherLiabilityType": "Alimony",
      "shouldBePaidInFull": true,
      "unpaidBalanceAmount": 553
    }
  ],
  "loanPurpose": "Purchase",
  "lotAcquiredDate": "2019-10-31T19:00:00.000Z",
  "lotOriginalCost": 200.3,
  "monthsBeforeFirstAdj": 2,
  "monthsBetweenAdjustments": 3,
  "mortgageLienType": "First Lien",
  "mortgageProgramType": "Conventional",
  "name": "Loan1",
  "nativeLandTenure": "Fee Simple (On a Reservation)",
  "otherAmortizationType": "Test Amortization type",
  "otherLoanFeature": "Test Loan Feature",
  "otherLoanPurpose": "Test Loan Purpose",
  "otherMortgageProgramType": "Test program",
  "otherRefinanceProgType": "Test Refinance",
  "prepayPenaltyTermMonth": 5,
  "projectType": "Cooperative",
  "properties": [
    {
      "esMonthlyRentalIncome": 400506,
      "esNetMonthlyRentalIncome": 304056,
      "extendedFields": [],
      "externalId": "a57f5b81-477b-41a3-a647-5852562913e5",
      "isManufacturedHome": true,
      "isMixedUseProperty": true,
      "loanPurposeType": "Purchase",
      "name": "Prop1",
      "propertyUseType": "Primary Residence",
      "propertyValue": 50500555,
      "requestedLoanAmount": 5005000,
      "unitsFinancedCount": 5
    }
  ],
  "refinanceProgramType": "Full Documentation",
  "refinanceType": "No Cash Out",
  "status": "New",
  "titleHolders": [
    {
      "extendedFields": [],
      "externalId": "e8d51e2a-7d97-4da0-8356-ca86995d3d39",
      "isCurrentTitleHolder": true,
      "name": "T1",
      "titleHolderName": "Times"
    }
  ],
  "titleType": "Joint Tenancy with Right of Survivorship",
  "trustTitleType": "Title Will be Held by an Inter Vivos (Living) Trust"
}
$$
);