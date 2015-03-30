//
//  DatabaseQueryHandler.h
//  eWallet
//
//  Created by Mummidi, Raja on 12/22/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseQueryHandler : NSObject
{
   
    
}

+(BOOL)validateCustomer:(NSString *)strCustomer_id andPassword:(NSString*)strPassword;
+(NSArray *)getCustomerDetails:(NSString *)strCustomer_id andPassword:(NSString*)strPassword;
+(NSMutableArray *)getCustomerCardDetails:(NSString *)strCustomer_id;
+(NSMutableArray *)getCustomerCardTypes:(NSString *)strCustomer_id;
+(NSMutableArray *)getCustomerCardDetails:(NSString *)strCustomer_id andCardNumber:(NSString *)strCardNumber;
+(NSMutableArray *)getCustomerCardTransactionDetails:(NSString *)strCustomer_id;

+(void)insertCardDetails:(NSMutableDictionary *)cardDetails;

@end
