//
//  Constant.h
//  eWallet
//
//  Created by Mummidi, Raja on 12/22/14.
//
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject

#define kLibraryPath   [NSHomeDirectory() stringByAppendingString:@"/Library"];
#define kDocumentsPath [NSHomeDirectory() stringByAppendingString:@"/Documents"];


#define kAccountLogin @"http://wnl-svr031f.wellsfargo.com:3000/get?namedQuery=custlogin"
#define kGetCardsTrans @"http://wnl-svr031f.wellsfargo.com:3000/get?namedQuery=cardtrans"
#define kGetCardsList @"http://wnl-svr031f.wellsfargo.com:3000/get?namedQuery=custcards"
#define kGetCardsTypes @"http://wnl-svr031f.wellsfargo.com:3000/get?namedQuery=cardstypes"
#define kCustomerCareFacetime @"facetime://customercare@wellsfargo.com"



@end
