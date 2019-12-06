//
//  SafariExtensionHandler.m
//  Injector Extension
//
//  Created by Cheng Zhao on 2019/12/06.
//  Copyright © 2019 Cheng Zhao. All rights reserved.
//

#import "SafariExtensionHandler.h"
#import "SafariExtensionViewController.h"

@interface SafariExtensionHandler ()

@end

@implementation SafariExtensionHandler

- (void)messageReceivedWithName:(NSString *)messageName fromPage:(SFSafariPage *)page userInfo:(NSDictionary *)userInfo {
  if ([messageName isEqualToString:@"dom-onload"])
    [self handleOnLoad:page];
  else if ([messageName isEqualToString:@"extension-loaded"])
    [self handleExtensionLoaded:page];
}

- (void)toolbarItemClickedInWindow:(SFSafariWindow *)window {
  // This method will be called when your toolbar item is clicked.
  NSLog(@"The extension's toolbar item was clicked");
}

- (void)validateToolbarItemInWindow:(SFSafariWindow *)window validationHandler:(void (^)(BOOL enabled, NSString *badgeText))validationHandler {
  // This method will be called whenever some state changes in the passed in window. You should use this as a chance to enable or disable your toolbar item and set badge text.
  validationHandler(NO, nil);
}

- (SFSafariExtensionViewController *)popoverViewController {
  return [SafariExtensionViewController sharedController];
}

- (void)handleOnLoad:(SFSafariPage *)page {
  [page dispatchMessageToScriptWithName:@"dom-onload" userInfo:@{@"myKey":@"myValue"}];
}

- (void)handleExtensionLoaded:(SFSafariPage *)page {
  [page dispatchMessageToScriptWithName:@"extension-loaded" userInfo:@{@"myKey":@"myValue"}];
}

@end
