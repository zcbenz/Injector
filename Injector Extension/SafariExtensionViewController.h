//
//  SafariExtensionViewController.h
//  Injector Extension
//
//  Created by Cheng Zhao on 2019/12/06.
//  Copyright © 2019 Cheng Zhao. All rights reserved.
//

#import <SafariServices/SafariServices.h>

@interface SafariExtensionViewController : SFSafariExtensionViewController

+ (SafariExtensionViewController *)sharedController;

@end
