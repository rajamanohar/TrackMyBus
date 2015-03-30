//
//  DatabaseQueryHandler.m
//  eWallet
//
//  Created by Mummidi, Raja on 12/22/14.
//
//

#import "DatabaseQueryHandler.h"
#import "Utility.h"
#import "Constant.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
@implementation DatabaseQueryHandler
static sqlite3 *eWalletDatabase;
static   NSString *strDatabasePath;
+(BOOL)validateCustomer:(NSString *)strCustomer_id andPassword:(NSString*)strPassword
{
    const char *sql = "SELECT * FROM Customers where id=? and password=?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(eWalletDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [strCustomer_id UTF8String], -1,  SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [strPassword UTF8String], -1,  SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_ROW) {
            return YES;

        }
    }
    sqlite3_finalize(statement);
    
    return NO;
    
}
+(NSArray *)getCustomerDetails:(NSString *)strCustomer_id andPassword:(NSString*)strPassword
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate  managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeesInfo"
                                                                                      inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
   
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"employee_id"]);
        NSLog(@"Password: %@", [info valueForKey:@"password"]);
     //   NSManagedObject *details = [info valueForKey:@"details"];
        //NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
    }
    
    
    return fetchedObjects;
   
}
+(NSMutableArray *)getCustomerCardDetails:(NSString *)strCustomer_id
{
    NSMutableArray *arrCust=[[NSMutableArray alloc] init];
    
    const char *dbpath = [[self getDatabasePath] UTF8String];
    if (sqlite3_open(dbpath, &eWalletDatabase) == SQLITE_OK)
    {
        
        const char *sql = "select type,cvv,name,available_balance,nameoncard,validfrom,validthru,number from card where customer_id=?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(eWalletDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [strCustomer_id UTF8String], -1,  SQLITE_TRANSIENT);
            // sqlite3_bind_text(statement, 2, [strCardNumber UTF8String], -1,  SQLITE_TRANSIENT);
            
            while(sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dictCustomer=[[NSMutableDictionary alloc] init];
                
                NSString*  strType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString*  strCvv = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString*  strName =    [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString*  strAvailableBalance =     [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString*  strNameoncard=      [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                NSString*  strValidfrom = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                NSString*  strValidthru = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                NSString*  strNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                
                [dictCustomer setObject:strType forKey:@"type"];
                [dictCustomer setObject:strCvv forKey:@"ccv"];
                [dictCustomer setObject:strName forKey:@"name"];
                [dictCustomer setObject:strAvailableBalance forKey:@"available_balance"];
                [dictCustomer setObject:strNameoncard forKey:@"nameoncard"];
                [dictCustomer setObject:strValidfrom forKey:@"validfrom"];
                [dictCustomer setObject:strValidthru forKey:@"validthru"];
                [dictCustomer setObject:strNumber forKey:@"number"];
                
                [arrCust addObject:dictCustomer];
            }
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(eWalletDatabase);
    return arrCust;
    
}

+(NSMutableArray *)getCustomerCardTypes:(NSString *)strCustomer_id
{
    NSMutableArray *arrCust=[[NSMutableArray alloc] init];
    
    const char *dbpath = [[self getDatabasePath] UTF8String];
    if (sqlite3_open(dbpath, &eWalletDatabase) == SQLITE_OK)
    {
        
        const char *sql = "select type,count(*) as count from  card where customer_id=? group by type order by type asc";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(eWalletDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [strCustomer_id UTF8String], -1,  SQLITE_TRANSIENT);
            
            while(sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dictCustomer=[[NSMutableDictionary alloc] init];
                
                NSString*  strType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString*  strCount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [dictCustomer setValue:strType forKey:@"type"];
                [dictCustomer setValue:strCount forKey:@"count"];
                
                [arrCust addObject:dictCustomer];
            }
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(eWalletDatabase);
    return arrCust;
    
}

+(NSMutableArray *)getCustomerCardTransactionDetails:(NSString *)strCustomer_id
{
    NSMutableArray *arrCust=[[NSMutableArray alloc] init];
    
    const char *dbpath = [[self getDatabasePath] UTF8String];
    if (sqlite3_open(dbpath, &eWalletDatabase) == SQLITE_OK)
    {
        
        const char *sql = "select trans_id,trans_date,trans_amount from transactions where customer_id=? ";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(eWalletDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [strCustomer_id UTF8String], -1,  SQLITE_TRANSIENT);
            // sqlite3_bind_text(statement, 2, [strCardNumber UTF8String], -1,  SQLITE_TRANSIENT);
            
            while(sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dictCustomer=[[NSMutableDictionary alloc] init];
                
                NSString*  strtrans_id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString*  strtrans_date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString*  strtrans_amount =     [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
             
                
                
                [dictCustomer setObject:strtrans_id forKey:@"trans_id"];
                [dictCustomer setObject:strtrans_date forKey:@"trans_date"];
                [dictCustomer setObject:strtrans_amount forKey:@"trans_amount"];
             
                
                [arrCust addObject:dictCustomer];
            }
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(eWalletDatabase);
    return arrCust;
    
}
+(void)insertCardDetails:(NSMutableDictionary *)cardDetails
{
    const char *dbpath = [[self getDatabasePath] UTF8String];
    if (sqlite3_open(dbpath, &eWalletDatabase) == SQLITE_OK)
    {
        
        const char *sql = "insert into card (number,cvv,validthru,validfrom,type,name,nameoncard,available_balance,customer_id) values (?,?,?,?,?,?,?,?,?)";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(eWalletDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [[cardDetails objectForKey:@""] UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(statement, 1, [[cardDetails objectForKey:@""] UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(statement, 1, [[cardDetails objectForKey:@""] UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(statement, 1, [[cardDetails objectForKey:@""] UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(statement, 1, [[cardDetails objectForKey:@""] UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(statement, 1, [[cardDetails objectForKey:@""] UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(statement, 1, [[cardDetails objectForKey:@""] UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(statement, 1, [[cardDetails objectForKey:@""] UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(statement, 1, [[cardDetails objectForKey:@""] UTF8String], -1,  SQLITE_TRANSIENT);
            if(sqlite3_step(statement) == SQLITE_ROW) {
               
            }
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(eWalletDatabase);
    
}

+(NSString *)getDatabasePath
{
    
    NSString *docsDir=[[NSString alloc]init];
    docsDir=kLibraryPath;
    
    strDatabasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"eWallet.sqlite"]];
   // BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:strDatabasePath ] == YES)
        return strDatabasePath;
    
     return @"";
}
@end
