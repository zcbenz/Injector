//
//  SafariExtensionHandler.m
//  Injector Extension
//
//  Created by Cheng Zhao on 2019/12/06.
//  Copyright © 2019 Cheng Zhao. All rights reserved.
//

#import "SafariExtensionHandler.h"
#import "SafariExtensionViewController.h"

#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>

NSString *RealHomeDirectory() {
  struct passwd *pw = getpwuid(getuid());
  return [NSString stringWithUTF8String:pw->pw_dir];
}

NSDictionary *ReadFile(NSString *path) {
  NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  if (content)
    return @{ @"content": content };
  else
    return @{ @"error": @"File read error" };
}

NSMutableDictionary* SearchFiles(NSString *dir) {
  NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *files = [[NSMutableDictionary alloc] init];
  NSFileManager* fm = [NSFileManager defaultManager];

  NSArray<NSString*> *contents = [fm contentsOfDirectoryAtPath:dir error:nil];
  for (NSString* filename in contents) {
    NSString *filepath = [dir stringByAppendingPathComponent:filename];
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:filepath isDirectory:&isDir])
      files[filename] = isDir ? SearchFiles(filepath) : ReadFile(filepath);
  }
  result[@"files"] = files;
  return result;
}

@interface SafariExtensionHandler (Private)
- (void)handleExtensionLoaded:(SFSafariPage *)page;
@end

@implementation SafariExtensionHandler

- (id)init {
  NSString *configDir = [RealHomeDirectory() stringByAppendingPathComponent:@".injector"];
  self.config = SearchFiles(configDir);
  self.config[@"configDir"] = configDir;
  return [super init];
}

- (void)messageReceivedWithName:(NSString *)messageName fromPage:(SFSafariPage *)page userInfo:(NSDictionary *)userInfo {
  if ([messageName isEqualToString:@"extension-loaded"])
    [self handleExtensionLoaded:page];
}

- (void)toolbarItemClickedInWindow:(SFSafariWindow *)window {
  // This method will be called when your toolbar item is clicked.
}

- (void)validateToolbarItemInWindow:(SFSafariWindow *)window validationHandler:(void (^)(BOOL enabled, NSString *badgeText))validationHandler {
  // This method will be called whenever some state changes in the passed in window. You should use this as a chance to enable or disable your toolbar item and set badge text.
  validationHandler(NO, nil);
}

- (SFSafariExtensionViewController *)popoverViewController {
  return [SafariExtensionViewController sharedController];
}

- (void)handleExtensionLoaded:(SFSafariPage *)page {
  [page dispatchMessageToScriptWithName:@"extension-loaded" userInfo:self.config];
}

@end
