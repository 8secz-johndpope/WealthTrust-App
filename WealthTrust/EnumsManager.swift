//
//  EnumsManager.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 9/5/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit


let kSelectFromFundValue = "kSelectFromFund"
let kSelectToFundValue = "kSelectToFund"
let kSelectBuyNowScheme = "kBuyNowScheme"
let kSelectAddExistingScheme = "kSelectAddExistingScheme"



let MFU_TXN_TYPE_ADDITIONAL_BUY = "A";
let MFU_TXN_TYPE_BUY = "B";
let MFU_TXN_TYPE_NFO = "N";
let MFU_TXN_TYPE_SIP = "V";
let MFU_TXN_TYPE_REDEEM = "R";
let MFU_TXN_TYPE_SWP = "J";
let MFU_TXN_TYPE_SWITCH_IN = "I";
let MFU_TXN_TYPE_SWITCH_OUT = "O";
let MFU_TXN_TYPE_STP_IN = "X";
let MFU_TXN_TYPE_STP_OUT = "Y";


enum InfoMode {
    case PersonalInfoMode
    case BankInfoMode
    case IdentitykInfoMode
    case NominyInfoMode
    case SignatureInfoMode
    
    static let allValues = ["PersonalInfoMode", "BankInfoMode", "IdentitykInfoMode", "NominyInfoMode", "SignatureInfoMode"]
}

enum ModeOfHolding {
    case Single
    static let allValues = ["Single"]
    
    static func fromHashValue(hashValue: Int) -> ModeOfHolding {
        if hashValue == 0 {
            return .Single
        }
        return Single
    }
}

enum TaxStatus {
    case ResidentIndividual
    case SoleProprietor
    static let allValues = ["Resident Individual", "Sole Proprietor"]
    
    static func fromHashValue(hashValue: Int) -> TaxStatus {
        if hashValue == 0 {
            return .ResidentIndividual
        } else if hashValue == 1 {
            return .SoleProprietor
        }

        return ResidentIndividual
    }

}


enum InvestorCategory {
    case Individual
    case Minor
    case SoleProprietor
    static let allValues = ["Individual", "Minor", "Sole Proprietor"]
}

enum ResidentialStatus {
    case ResiIndia
    case NRINRE
    case NRINRO
    case ForeignNational
    case PIO
    static let allValues = ["Resi-India", "NRI-NRE", "NRI-NRO", "Foreign National", "PIO"]
}

enum RelationshipWithMinor {
    case Father
    case Mother
    case CourtAppliedLegalGurdian
    static let allValues = ["Father", "Mother", "Court applied legal gurdian"]
}

enum AccType {
    case Savings
    case Current
    case CashCredit
    case OD
    case NRE
    case NRO
    case FCNR
    case NRSR
    case Other
    static let allValues = ["Savings", "Current", "Cash Credit", "O/D", "NRE", "NRO", "FCNR", "NRSR", "Other"]
    
    static func fromHashValue(hashValue: Int) -> AccType {
        if hashValue == 0 {
            return .Savings
        } else if hashValue == 1 {
            return .Current
        }else if hashValue == 2 {
            return .CashCredit
        }else if hashValue == 3 {
            return .OD
        }else if hashValue == 4 {
            return .NRE
        }else if hashValue == 5 {
            return .NRO
        }else if hashValue == 6 {
            return .FCNR
        }else if hashValue == 7 {
            return .NRSR
        }else if hashValue == 8 {
            return .Other
        }

        return Savings
    }

}

enum ProofOfAccount {
    case CancelledChequeOrCopy
    case BankPasbook
    case BankStatement
    case LetterFromBankConfirmingAccount
    static let allValues = ["Cancelled Cheque", "Bank Pasbook", "Bank Statement", "Letter From Bank"]
    
    static func fromHashValue(hashValue: Int) -> ProofOfAccount {
        if hashValue == 0 {
            return .CancelledChequeOrCopy
        } else if hashValue == 1 {
            return .BankPasbook
        }else if hashValue == 2 {
            return .BankStatement
        }else if hashValue == 3 {
            return .LetterFromBankConfirmingAccount
        }
        
        return CancelledChequeOrCopy
    }
}

enum GrossAnualIncome {
    case Less1L
    case OneTo5Lakh
    case FiveTo10L
    case TenTo25L
    case Twenty5To1Crore
    case Greater1Crore
    static let allValues = ["₹ <1L", "₹ 1-5L", "₹ 5-10L", "₹ 10-25L", "₹ 25 L-1 crore", "₹ >1 Crore"]
    
    static func fromHashValue(hashValue: Int) -> GrossAnualIncome {
        if hashValue == 0 {
            return .Less1L
        } else if hashValue == 1 {
            return .OneTo5Lakh
        }else if hashValue == 2 {
            return .FiveTo10L
        }else if hashValue == 3 {
            return .TenTo25L
        }else if hashValue == 4 {
            return .Twenty5To1Crore
        }else if hashValue == 5 {
            return .Greater1Crore
        }
        
        return Less1L
    }
}


enum PrimarySourceOfWealth {
    case Salary
    case BusinessIncome
    case Gift
    case AncestralProperty
    case RentalIncome
    case PrizeMoney
    case Royalty
    case Other
    static let allValues = ["Salary", "Business Income", "Gift", "Ancestral Property", "Rental Income", "Prize Money", "Royalty", "Other"]
    
    
    static func fromHashValue(hashValue: Int) -> PrimarySourceOfWealth {
        if hashValue == 0 {
            return .Salary
        } else if hashValue == 1 {
            return .BusinessIncome
        }else if hashValue == 2 {
            return .Gift
        }else if hashValue == 3 {
            return .AncestralProperty
        }
        else if hashValue == 4 {
            return .RentalIncome
        }else if hashValue == 5 {
            return .PrizeMoney
        }else if hashValue == 6 {
            return .Royalty
        }else if hashValue == 7 {
            return .Other
        }
        
        return Salary
    }

    
}

enum Occupation {
    case Business
    case Service
    case Professional
    case Agriculturist
    case Retired
    case Housewife
    case Student
    case Doctor
    case PvtSector
    case PublicSector
    case ForexDealer
    case GovernmentServices
    case Other
    static let allValues = ["Business", "Service", "Professional", "Agriculturist", "Retired", "Housewife", "Student", "Doctor", "Pvt Sector", "Public Sector", "Forex Dealer", "Government Services", "Other"]
    
    static func fromHashValue(hashValue: Int) -> Occupation {
        if hashValue == 0 {
            return .Business
        } else if hashValue == 1 {
            return .Service
        }else if hashValue == 2 {
            return .Professional
        }else if hashValue == 3 {
            return .Agriculturist
        }else if hashValue == 4 {
            return .Retired
        }else if hashValue == 5 {
            return .Housewife
        }else if hashValue == 6 {
            return .Student
        }else if hashValue == 7 {
            return .Doctor
        }else if hashValue == 8 {
            return .PvtSector
        }else if hashValue == 9 {
            return .PublicSector
        }else if hashValue == 10 {
            return .ForexDealer
        }else if hashValue == 11 {
            return .GovernmentServices
        }else if hashValue == 12 {
            return .Other
        }
        
        return Business
    }

    
    
}

enum PoliticallyExposedPerson {
    case AmAPEP
    case RelatedToPEP
    case NA
    
    static let allValues = ["Yes", "Related to PEP", "Not Applicable"]

    static func fromHashValue(hashValue: Int) -> PoliticallyExposedPerson {
        if hashValue == 0 {
            return .AmAPEP
        } else if hashValue == 1 {
            return .RelatedToPEP
        }else if hashValue == 2 {
            return .NA
        }
        
        return AmAPEP
    }

}
enum NomineeRelationship {
    case Wife
    case Husband
    case Mother
    case Father
    case Other
    
    static let allValues = ["Wife", "Husband", "Mother", "Father", "Other"]
    
    static func fromHashValue(hashValue: Int) -> NomineeRelationship {
        if hashValue == 0 {
            return .Wife
        }else if hashValue == 1 {
            return .Husband
        }else if hashValue == 2 {
            return .Mother
        }else if hashValue == 3 {
            return .Father
        }else if hashValue == 4 {
            return .Other
        }
        
        return Wife
    }
    
}

enum TypeOfAddressGivenAtKra {
    case ResidentialOrBusiness
    case Residential
    case Business
    case RegisteredOffice
    static let allValues = ["Residential Or Business", "Residential", "Business", "Registered Office"]
    
    static func fromHashValue(hashValue: Int) -> TypeOfAddressGivenAtKra {
        if hashValue == 0 {
            return .ResidentialOrBusiness
        } else if hashValue == 1 {
            return .Residential
        }else if hashValue == 2 {
            return .Business
        }else if hashValue == 3 {
            return .RegisteredOffice
        }
        
        return ResidentialOrBusiness
    }
    
}

enum DocumentType {
    case Pan
    case Selfie
    case Bankproof
    case Signature
    case MFStatement
    static let allValues = ["PAN", "Selfie", "Bankproof", "Signature", "MFStatement"]
}

enum YesNo {
    case No
    case Yes

    static let allValues = ["No", "Yes"]
    
    static func fromHashValue(hashValue: Int) -> YesNo {
        if hashValue == 0 {
            return .No
        } else if hashValue == 1 {
            return .Yes
        }
        return No
    }
}



enum IS_FROM {
    
    case Profile
    case SwitchToDirect
    case SmartSavings
    case MyOrders
    case AddManuallyPortfolio
    case AutoGenerate
    case Transaction
    case BuySIP
    case BuySIPFromTopFunds
    case BuySIPFromSearch
    case BuySIPFromPortfolio
    static let allValues = ["Profile", "Switch To Direct", "Smart Savings", "My Orders", "AddManuallyPortfolio", "AutoGenerate", "Transaction", "BuySIP", "BuySIPFromTopFunds", "BuySIPFromSearch", "BuySIPFromPortfolio"]
    
}


enum SIGNUP_STATUS {
    
    case PENDING0
    case CREATED1
    case VERIFIED2
    case INVALID3
    case PANVERIFICATIONPENDING4

}

enum INVESTMENTAACCOUNT_STATUS {
    
    case PENDING0
    case PROCESSING1
    case CANGENERATED2
    case VERIFIED3
    case INVALID4
}

enum OrderStatus {
    case Processing
    case Accepted
    case Rejected
    case InvalidMFStmt
    case Failed
    case SystemError
    case InvalidFolioNumber
    case OrderDoesNotExist
    case SessionTimeOut
    case WatingforAllotment
    case RQ
    case OR
    case SA
    case SR
    case RA
    case RP
    case RR
    case Cancelled
    case OA
    case CL
    case SENT_TO_MFU
    
    static let allValues = ["Processing", "Accepted", "Rejected", "InvalidMFStmt", "Failed", "SystemError", "InvalidFolioNumber", "OrderDoesNotExist", "SessionTimeOut", "WatingforAllotment", "Accepted", "Rejected", "Accepted","Rejected","Accepted","Executed","Accepted","Cancelled","OA","Cancelled","Processing Payment"]
    
    static func fromHashValue(hashValue: Int) -> OrderStatus {
        if hashValue == 0 {
            return .Processing
        } else if hashValue == 1 {
            return .Accepted
        }else if hashValue == 2 {
            return .Rejected
        }else if hashValue == 3 {
            return .InvalidMFStmt
        }else if hashValue == 4 {
            return .Failed
        }else if hashValue == 5 {
            return .SystemError
        }else if hashValue == 6 {
            return .InvalidFolioNumber
        }else if hashValue == 7 {
            return .OrderDoesNotExist
        }else if hashValue == 8 {
            return .SessionTimeOut
        }else if hashValue == 9 {
            return .WatingforAllotment
        }else if hashValue == 10 {
            return .RQ
        }else if hashValue == 11 {
            return .OR
        }else if hashValue == 12 {
            return .SA
        }else if hashValue == 13 {
            return .SR
        }else if hashValue == 14 {
            return .RA
        }else if hashValue == 15 {
            return .RP
        }else if hashValue == 16 {
            return .RR
        }else if hashValue == 17 {
            return .Cancelled
        }else if hashValue == 18 {
            return .OA
        }else if hashValue == 19 {
            return .CL
        }else if hashValue == 20 {
            return .SENT_TO_MFU
        }
        
        return Processing
    }
    
    
    
}

enum OrderType {
    case SwitchWithOutDocs
    case SwitchWithDocs
    case STPWithOutDocs
    case STPWithDocs
    case RedeemWithOutDocs
    case RedeemWithDocs
    case SWPWithOutDocs
    case SWPWithDocs
    case Buy
    case SIP
    case BuyPlusSIP
    
    static let allValues = ["SwitchWithOutDocs", "SwitchWithDocs", "STPWithOutDocs", "STPWithDocs", "RedeemWithOutDocs", "RedeemWithDocs", "SWPWithOutDocs", "SWPWithDocs", "Buy", "SIP", "BuyPlusSIP"]
    
    static func fromHashValue(hashValue: Int) -> OrderType {
        if hashValue == 0 {
            return .SwitchWithOutDocs
        } else if hashValue == 1 {
            return .SwitchWithDocs
        }else if hashValue == 2 {
            return .STPWithOutDocs
        }else if hashValue == 3 {
            return .STPWithDocs
        }else if hashValue == 4 {
            return .RedeemWithOutDocs
        }else if hashValue == 5 {
            return .RedeemWithDocs
        }else if hashValue == 6 {
            return .SWPWithOutDocs
        }else if hashValue == 7 {
            return .SWPWithDocs
        }else if hashValue == 8 {
            return .Buy
        }else if hashValue == 9 {
            return .SIP
        }else if hashValue == 10 {
            return .BuyPlusSIP
        }
        
        return SwitchWithOutDocs
    }
}

enum CartFlag {
    case NotInCart
    case InCart
    case DeletedFromCart
    
    static let allValues = ["NotInCart", "InCart", "DeletedFromCart"]
    
    static func fromHashValue(hashValue: Int) -> CartFlag {
        if hashValue == 0 {
            return .NotInCart
        } else if hashValue == 1 {
            return .InCart
        }else if hashValue == 2 {
            return .DeletedFromCart
        }
        
        return NotInCart
    }
}

enum DividentOption {
    case Notapplicable
    case Reinvestment
    case Payout
    
    static let allValues = ["Not applicable","Re investment", "Payout"]
    
    static func fromHashValue(hashValue: Int) -> DividentOption {
        if hashValue == 0 {
            return .Notapplicable
        } else if hashValue == 1 {
            return .Reinvestment
        }else if hashValue == 2 {
            return .Payout
        }
        
        return Notapplicable
    }
}

enum TransactionVolumeType {
    case ALLUNITS
    case UNITS
    case AMOUNT
    
    static let allValues = ["ALL UNITS","UNITS", "AMOUNT"]
    
    static func fromHashValue(hashValue: Int) -> TransactionVolumeType {
        if hashValue == 0 {
            return .ALLUNITS
        } else if hashValue == 1 {
            return .UNITS
        }else if hashValue == 2 {
            return .AMOUNT
        }
        
        return ALLUNITS
    }
}

enum FundCategory {
    case ALL
    case Balanced
    case Debt
    case ELSS
    case Equity
    case FundofFunds
    case GOLDETFs
    case Liquid
    case NA
    case OtherETFs
    
    static let allValues = ["ALL","Balanced", "Debt", "ELSS", "Equity", "Fund of Funds", "GOLD ETFs", "Liquid", "N.A", "Other ETFs"]
    
    static func fromHashValue(hashValue: Int) -> FundCategory {
        if hashValue == 0 {
            return .ALL
        } else if hashValue == 1 {
            return .Balanced
        }else if hashValue == 2 {
            return .Debt
        }else if hashValue == 3 {
            return .ELSS
        }else if hashValue == 4 {
            return .Equity
        }else if hashValue == 5 {
            return .FundofFunds
        }else if hashValue == 6 {
            return .GOLDETFs
        }else if hashValue == 7 {
            return .Liquid
        }else if hashValue == 8 {
            return .NA
        }else if hashValue == 9 {
            return .OtherETFs
        }
        
        return ALL
    }
}


enum DividendOptionBUY {
    case Payout
    case Reinvestment
    
    static let allValues = ["Payout","Reinvestment"]
    
    static func fromHashValue(hashValue: Int) -> DividendOptionBUY {
        if hashValue == 0 {
            return .Payout
        } else if hashValue == 1 {
            return .Reinvestment
        }
        return Payout
    }
}

enum Frequency {
    case SELECT
    case Daily
    case Monthly
    case Weekly

    static let allValues = ["SELECT","Daily","Monthly", "Weekly"]
    
    static func fromHashValue(hashValue: Int) -> Frequency {
        if hashValue == 0 {
            return .SELECT
        } else if hashValue == 1 {
            return .Daily
        }else if hashValue == 2 {
            return .Monthly
        }else if hashValue == 3 {
            return .Weekly
        }
        
        return SELECT
    }
}

enum MONTH {
    case SELECT
    case JAN
    case FEB
    case MAR
    case APR
    case MAY
    case JUN
    case JUL
    case AUG
    case SEP
    case OCT
    case NOV
    case DEC

    static let allValues = ["SELECT","JAN","FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    
    static func fromHashValue(hashValue: Int) -> MONTH {
        if hashValue == 0 {
            return .SELECT
        }else if hashValue == 1 {
            return .JAN
        } else if hashValue == 2 {
            return .FEB
        }else if hashValue == 3 {
            return .MAR
        }else if hashValue == 4 {
            return .APR
        }else if hashValue == 5 {
            return .MAY
        }else if hashValue == 6 {
            return .JUN
        }else if hashValue == 7 {
            return .JUL
        }else if hashValue == 8 {
            return .AUG
        }else if hashValue == 9 {
            return .SEP
        }else if hashValue == 10 {
            return .OCT
        }else if hashValue == 11 {
            return .NOV
        }else if hashValue == 12 {
            return .DEC
        }
        return SELECT
    }
    
    static func fromHashString(strValue: String) -> MONTH {
        var i = 0;
        for value in allValues
        {
            if(value == strValue)
            {
                return fromHashValue(i)
            }
            i += 1
            
        }
        return MONTH.SELECT
    }
}

enum YEAR {
    case y2013
    case y2014
    case y2015
    case y2016
    case y2017
    case y2018
    
    static let allValues = ["2013","2014", "2015", "2016", "2017", "2018"]
    
    static func fromHashValue(hashValue: Int) -> YEAR {
        if hashValue == 0 {
            return .y2013
        } else if hashValue == 1 {
            return .y2014
        }else if hashValue == 2 {
            return .y2015
        }else if hashValue == 3 {
            return .y2016
        }else if hashValue == 4 {
            return .y2017
        }else if hashValue == 5 {
            return .y2018
        }
        return y2013
    }
}


class EnumsManager: NSObject {

}

enum SyncDynamicTextType {
    case SWT_TXN_SUCCESS_DIALOG
    case SWT_TXN_SUCCESS_SHARE
    case BUY_SIP_TXN_SUCCESS_DIALOG
    case BUY_SIP_TXN_SUCCESS_SHARE
    case REDEEM_TXN
    case KYC_PENDING
    case BUY_ORDER_REDIRECTION
    case SHARE_FROM_DRAWER
    case SIP_ORDER_INITIATED_BUT_PMRN_NOT_FOUND_IN_SYSTEM
    case BUY_PLUS_SIP_TXN_SUCCESS_DIALOG
    case BUY_PLUS_SIP_INTIATED
    case SHARE_FROM_DASHBOARD
    case SHARE_SAVINGS_CALC
    case SHARE_TOP_FUNDS
    case SHARE_FROM_MY_PORTFOLIO
    case BUY_IR_TXN_SUCCESS_DIALOG
    case BUY_IR_TXN_SUCCESS_SHARE
    case REDEEM_IR_TXN_SUCCESS_DIALOG
    case REDEEM_IR_TXN_SUCCESS_SHARE
}

public enum USERACTIONTYPE {
    case UA_SHARE_DRAWER
    case UA_SHARE_SAVINGSCACULATOR
    case UA_SHARE_TOPFUNDS
    case UA_SHARE_DASHBOARDBOTTOMBAR
    case UA_SHARE_BUY
    case UA_SHARE_SIP
    case UA_SHARE_SWITCH
    case UA_FACEBOOK
    case UA_TWITTER
    case UA_GPLUS
    case UA_RATEUS_DRAWER
    case UA_RATEUS_SWITCH
    case UA_RATEUS_BUY
    case UA_RATEUS_SIP
    case UA_RATEUS_DASHBOARDBOTTOMBAR
    case UA_SHARE_PORTFOLIO
    case UA_IGNORE_PORTFOLIO
    case UA_COMPLETE_KYC
    case UA_TRY_LATER_KYC
    case UA_TRY_NOW_KYC
    case UA_COMPLETED_KYC
    case UA_SHARE_IR_BUY
    case UA_SHARE_IR_REDEEM
    case UA_RATEUS_IR_BUY
    case UA_RATEUS_IR_REDEEM
    case UA_SHARE_PORTFOLIOBOTTOMBAR
    case UA_RATEUS_PORTFOLIOBOTTOMBAR
}
