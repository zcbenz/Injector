//
//  ViewController.h
//  Injector
//
//  Created by Cheng Zhao on 2019/12/06.
//  Copyright © 2019 Cheng Zhao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak, nonatomic) IBOutlet NSTextField * appNameLabel;

- (IBAction)openSafariExtensionPreferences:(id)sender;

@end

