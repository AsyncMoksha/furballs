//
//  AppDelegate.h
//  PAWS
//
//  Created by Pisit Praiwattana on 9/21/54 BE.
//  Copyright __MyCompanyName__ 2554. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
