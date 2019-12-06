//
//  ViewController.m
//  Injector
//
//  Created by Cheng Zhao on 2019/12/06.
//  Copyright © 2019 Cheng Zhao. All rights reserved.
//

#import "ViewController.h"
#import <SafariServices/SFSafariApplication.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appNameLabel.stringValue = @"Injector";
}

- (IBAction)openSafariExtensionPreferences:(id)sender {
    [SFSafariApplication showPreferencesForExtensionWithIdentifier:@"zcbenz.Injector-Extension" completionHandler:^(NSError * _Nullable error) {
        if (error) {
            // Insert code to inform the user something went wrong.
        }
    }];
}

@end
