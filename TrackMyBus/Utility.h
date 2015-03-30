//
//  Utility.h
//  eWallet
//
//  Created by Mummidi, Raja on 12/22/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Utility : NSObject
{
    
}

+(NSString* )convertDate:(NSString *)dateString fromInputFormat:(NSString *)inputString toOutputFormat:(NSString *)outputString;
+(UITableView *)setTableViewBorderColor:(UITableView *)tableview;
@end
