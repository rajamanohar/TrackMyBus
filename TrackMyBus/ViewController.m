//
//  ViewController.m
//  TrackMyBus
//
//  Created by Mummidi, Raja on 3/30/15.
//  Copyright (c) 2015 Mummidi, Raja. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "MapViewController.h"

@interface ViewController ()
@property(nonatomic,strong) LoginViewController *objLoginViewCtrl;
@property(nonatomic,strong) MapViewController *objMapViewCtrl;
@end

@implementation ViewController
@synthesize objLoginViewCtrl,objMapViewCtrl,managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)viewDidAppear:(BOOL)animated
{
    objMapViewCtrl=[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewCtrl"];
    objMapViewCtrl.view.frame=self.view.frame;
    [self.view addSubview:objMapViewCtrl.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) receiveLoginDetails:(NSNotification *) notification
{
       // NSDictionary *dict=[notification userInfo];
  
}
@end
