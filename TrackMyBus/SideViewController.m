//
//  SideViewController.m
//  TrackMyBus
//
//  Created by Mummidi, Raja on 4/6/15.
//  Copyright (c) 2015 Mummidi, Raja. All rights reserved.
//

#import "SideViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface SideViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrHeader,*arrBusOptions,*arrRoute,*arrSettings;
}

@property(nonatomic,strong) IBOutlet UIImageView *imgProfile;
@property(nonatomic,strong) IBOutlet UITableView *tblOptions;

@end

@implementation SideViewController
@synthesize imgProfile;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrHeader=@[@"Bus",@"Route",@"Settings"];
    
    arrBusOptions=@[@"Spot Location",@"Status",@"Driver Details"];
    arrRoute=@[@"Route Card",@"Change Request",@"Report Issue"];
    arrSettings=@[@"Alerts",@"Map Type"];

    
    imgProfile.layer.backgroundColor=[[UIColor whiteColor] CGColor];
    imgProfile.layer.borderWidth=1;
    imgProfile.layer.cornerRadius=25;
    imgProfile.layer.masksToBounds=YES;
    
    self.view.layer.borderWidth=1;
    self.view.layer.borderColor=[[UIColor darkGrayColor]CGColor];
 //   self.view.alpha=0.3;
    // Do any additional setup after loading the view.
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [arrHeader count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return [arrBusOptions count];
    }else if(section==1){
        return [arrRoute count];
    }else if(section==2){
          return [arrSettings count];
    }
    return 1;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"%@",[arrHeader objectAtIndex:section]];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader=[[UIView alloc] initWithFrame:CGRectMake(0, -10, tableView.frame.size.width, 50)];
    viewHeader.backgroundColor=[UIColor blackColor];
    viewHeader.alpha=0.4;
    UILabel *lblText=[[UILabel alloc ] initWithFrame:CGRectMake(10, 0, 150, 35)];
    lblText.text=[NSString stringWithFormat:@"%@",[arrHeader objectAtIndex:section]];
    lblText.font=[UIFont boldSystemFontOfSize:15];
    lblText.textColor=[UIColor whiteColor];
    lblText.backgroundColor=[UIColor clearColor];
    [viewHeader addSubview:lblText];
    return viewHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.font=[UIFont boldSystemFontOfSize:13];
    
    if(indexPath.section==0){
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[arrBusOptions objectAtIndex:indexPath.row]];
    }else if(indexPath.section==1){
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[arrRoute objectAtIndex:indexPath.row]];
    }else if(indexPath.section==2){
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[arrSettings objectAtIndex:indexPath.row]];
    }
    UILabel *lblBackLine=[[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
    lblBackLine.backgroundColor=[UIColor blackColor];
    lblBackLine.alpha=0.3;
    [cell addSubview:lblBackLine];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
