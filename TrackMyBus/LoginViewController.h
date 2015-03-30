//
//  LoginViewController.h
//  eWallet
//
//  Created by Mummidi, Raja on 12/22/14.
//
//

#import <UIKit/UIKit.h>
@protocol LoginViewDelegate<NSObject>
-(void)didCompleteDownload:(NSArray *)arrEmployee;
@end


@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) id delegate;
@property(nonatomic,weak) IBOutlet UITextField *txtCustomerID;
@property(nonatomic,weak) IBOutlet UITextField *txtPasswrd;
@property(nonatomic,weak) IBOutlet UILabel *lblAuthenticate;
@property(nonatomic,weak) IBOutlet UIActivityIndicatorView *actIndicatorView;
@end
