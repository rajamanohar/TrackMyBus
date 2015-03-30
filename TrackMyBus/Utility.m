//
//  Utility.m
//  eWallet
//
//  Created by Mummidi, Raja on 12/22/14.
//
//

#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
@implementation Utility

+(NSString* )convertDate:(NSString *)dateString fromInputFormat:(NSString *)inputString toOutputFormat:(NSString *)outputString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:inputString];
    NSDate *theDate = [formatter dateFromString:dateString];
   
    [formatter setDateFormat:outputString];
    NSString *finalString = [formatter stringFromDate:theDate];
    return finalString;
}
+(UITableView *)setTableViewBorderColor:(UITableView *)tableview
{
    tableview.layer.borderWidth=1.0f;
    tableview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tableview.layer.cornerRadius=2.0f;
    [tableview.layer setMasksToBounds:YES];
    return tableview;
}
@end
