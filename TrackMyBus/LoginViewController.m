//
//  LoginViewController.m
//  eWallet
//
//  Created by Mummidi, Raja on 12/22/14.
//
//

#import "LoginViewController.h"
#import "ServerCommunicator.h"
#import "Constant.h"
#import "DatabaseQueryHandler.h"
#import "ViewController.h"

@interface LoginViewController ()<ServerCommunicatorDelegate>
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtCustomerID.delegate=self;
    self.txtPasswrd.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.txtCustomerID.text=@"1504918";
    self.txtPasswrd.text=@"Wells1234";
    //[self onClickSignIn:nil];
}

-(IBAction)onClickSignIn:(id)sender
{
    if([self.txtCustomerID.text isEqualToString:@""] ||[self.txtPasswrd.text isEqualToString:@""]){
        
        self.lblAuthenticate.hidden=NO;
        self.lblAuthenticate.text=@"Customer ID and Password can't be empty";
        [self.actIndicatorView stopAnimating];
    }
    else{
        
        ServerCommunicator *objServerCommunicator=[[ServerCommunicator alloc] init];
        objServerCommunicator.delegate=self;
       // [objServerCommunicator requestWithQuery:[NSString stringWithFormat:@"%@&dbo_customerid=%@&dbo_password=%@",kAccountLogin,self.txtCustomerID.text,self.txtPasswrd.text]];
        
        NSArray *arrResponse=[DatabaseQueryHandler getCustomerDetails:self.txtCustomerID.text andPassword:self.txtPasswrd.text];
        [self didDownloadComplete:arrResponse];
        
        
        self.actIndicatorView.hidden=NO;
        [self.actIndicatorView startAnimating];
    }
}

- (void)didDownloadComplete:(NSArray *)arrResponse
{
    [self.actIndicatorView stopAnimating];
    
    if([arrResponse count]>0){
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];;
  
            [dict  setObject:arrResponse forKey:@"details"];
            
        ViewController *viewCtrl=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewCtrl"];
        UINavigationController *navCtrl=[[UINavigationController alloc] initWithRootViewController:viewCtrl];
        [self presentViewController:navCtrl animated:YES completion:nil];
            return ;
       
    }
    
    self.lblAuthenticate.hidden=NO;
    self.lblAuthenticate.text=@"Incorrect Credentials";
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.lblAuthenticate.hidden=YES;
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    self.lblAuthenticate.hidden=YES;
    return YES;
}


@end
