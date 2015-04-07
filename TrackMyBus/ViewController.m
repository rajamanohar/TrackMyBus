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
#import "SideViewController.h"

@interface ViewController ()
@property(nonatomic,strong)  UIBarButtonItem *bbtnOptions;
@property(nonatomic,strong) LoginViewController *objLoginViewCtrl;
@property(nonatomic,strong) MapViewController *objMapViewCtrl;
@property(nonatomic,strong) SideViewController *objSideViewCtrl;
@end

@implementation ViewController
@synthesize bbtnOptions,objLoginViewCtrl,objMapViewCtrl,objSideViewCtrl,managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   bbtnOptions=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"open_right_arrow_32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickOnBarButton:)];
    bbtnOptions.tag=0;
    self.navigationItem.leftBarButtonItem=bbtnOptions;
     
    objSideViewCtrl=[self.storyboard instantiateViewControllerWithIdentifier:@"sideViewCtrl"];
    objSideViewCtrl.view.frame=CGRectMake(-200, 60, 200, self.view.frame.size.height);
    [self.view addSubview:objSideViewCtrl.view];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTapNotification:)
                                                 name:@"mapTapGestureRecognizer"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePanNotification:)
                                                 name:@"mapPanGestureRecognizer"
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    objMapViewCtrl=[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewCtrl"];
    objMapViewCtrl.view.frame=self.view.frame;
    [self.view addSubview:objMapViewCtrl.view];
    [UIView animateWithDuration:1 animations:^{
      objSideViewCtrl.view.frame=CGRectMake(0, 60, 200, self.view.frame.size.height);
    } completion:^(BOOL finished){
        [self.view bringSubviewToFront:objSideViewCtrl.view];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) receiveLoginDetails:(NSNotification *) notification
{
       // NSDictionary *dict=[notification userInfo];
  
}
// action for side menu
-(void)clickOnBarButton:(id)sender
{
    [self.view bringSubviewToFront:objSideViewCtrl.view];
    [UIView animateWithDuration:0.5 animations:^{
        if(bbtnOptions.tag==1){
            bbtnOptions.tag=0;
            objSideViewCtrl.view.frame=CGRectMake(0, 60, 200, self.view.frame.size.height);
        }else{
            bbtnOptions.tag=1;
            objSideViewCtrl.view.frame=CGRectMake(-200, 60, 200, self.view.frame.size.height);
        }
    } completion:^(BOOL finished){
        
    }];
 
}

#pragma mark- Gesture handling delegates
- (void) receiveTapNotification:(NSNotification *) notification
{
    if(bbtnOptions.tag==0)
    [self clickOnBarButton:self.bbtnOptions];
}
- (void) receivePanNotification:(NSNotification *) notification
{
     [self clickOnBarButton:self.bbtnOptions];
}

@end
